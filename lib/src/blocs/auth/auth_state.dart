part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class SendingPhoneConfirmation extends SigningIn {
  @override
  List<Object?> get props => [];
}

class ConfirmationCodeSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class CodeAutoRetrievalTimeout extends AuthState {
  final String verificationId;

  CodeAutoRetrievalTimeout({required this.verificationId});

  @override
  List<Object?> get props => [];
}

class VerificationFailed extends SignInFailed {
  final error;

  VerificationFailed({required this.error}) : super(error);

  @override
  List<Object?> get props => [error];
}

class SignedIn extends AuthState {
  final User? user;

  SignedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInFailed extends AuthState {
  final error;

  const SignInFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class SigningIn extends AuthState {
  @override
  List<Object?> get props => [];
}

class SigningInWithPhone extends SigningIn {
  @override
  List<Object?> get props => [];
}

class SignedInWithPhone extends SignedIn {
  SignedInWithPhone({required User? user}) : super(user);

  @override
  List<Object?> get props => [];
}

class SignedInWithPhoneFailed extends SignInFailed {
  final error;

  SignedInWithPhoneFailed({required this.error}) : super(error);

  @override
  List<Object?> get props => [error];
}

class SigningInWithGoogle extends SigningIn {
  @override
  List<Object?> get props => [];
}

class SignedInWithGoogle extends SignedIn {
  SignedInWithGoogle({required User? user}) : super(user);

  @override
  List<Object?> get props => [];
}

class SignedInWithGoogleFailed extends SignInFailed {
  final error;

  SignedInWithGoogleFailed({required this.error}) : super(error);

  @override
  List<Object?> get props => [error];
}

class SigningInWithFacebook extends SigningIn {
  @override
  List<Object?> get props => [];
}

class SignedInWithFacebook extends SignedIn {
  SignedInWithFacebook({required User? user}) : super(user);

  @override
  List<Object?> get props => [];
}

class SignedInWithFacebookFailed extends SignInFailed {
  final error;

  SignedInWithFacebookFailed({required this.error}) : super(error);

  @override
  List<Object?> get props => [error];
}

class SigningInWithApple extends SigningIn {
  @override
  List<Object?> get props => [];
}

class SignedInWithApple extends SignedIn {
  SignedInWithApple({required User? user}) : super(user);

  @override
  List<Object?> get props => [];
}

class SignedInWithAppleFailed extends SignInFailed {
  final error;

  SignedInWithAppleFailed({required this.error}) : super(error);

  @override
  List<Object?> get props => [error];
}
