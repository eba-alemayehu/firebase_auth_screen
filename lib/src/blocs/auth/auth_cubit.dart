import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'auth_state.dart';

typedef PhoneCodeSent = void Function(
    String verificationId,
    int? forceResendingToken,
    );

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> sendPhoneVerificationCode(String phoneNumber,
      {required PhoneCodeSent onCodeSent, int? resendToken}) async {
    emit(SendingPhoneConfirmation());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredintal = await FirebaseAuth.instance
            .signInWithCredential(credential);
        emit(SignedInWithPhone(userCredential: userCredintal));
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(VerificationFailed());
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(ConfirmationCodeSent());
        onCodeSent(verificationId, resendToken);
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(CodeAutoRetrievalTimeout());
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SigningInWithGoogle());
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    emit(SignedInWithGoogle(userCredential: userCredential));
  }

  Future<void> signInWithFacebook() async {
    emit(SigningInWithFacebook());
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken?.token ?? '');

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    emit(SignedInWithFacebook(userCredential: userCredential));
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    emit(SigningInWithApple());
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    emit(SignedInWithApple(userCredential: userCredential));
  }
}
