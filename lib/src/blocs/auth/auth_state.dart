part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class SendingPhoneConfirmation extends AuthState {
  @override
  List<Object?> get props => [];
}

class ConfirmationCodeSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class CodeAutoRetrievalTimeout extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerificationFailed extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedIn extends AuthState {
  final UserCredential userCredential;

  SignedIn(this.userCredential);

  @override
  List<Object?> get props => [userCredential];
}

class SignedInWithPhone extends SignedIn{
  SignedInWithPhone({required UserCredential userCredential}): super(userCredential);

  @override
  List<Object?> get props => [];
}

class SigningInWithGoogle extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedInWithGoogle extends SignedIn {
  SignedInWithGoogle({required UserCredential userCredential}): super(userCredential);

  @override
  List<Object?> get props => [];
}

class SignedInWithGoogleFailed extends AuthState {
  @override
  List<Object?> get props => [];
}

class SigningInWithFacebook extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedInWithFacebook extends SignedIn {
  SignedInWithFacebook({required UserCredential userCredential}): super(userCredential);

  @override
  List<Object?> get props => [];
}

class SignedInWithFacebookFailed extends AuthState {
  @override
  List<Object?> get props => [];
}

class SigningInWithApple extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedInWithApple extends SignedIn {
  SignedInWithApple({required UserCredential userCredential}): super(userCredential);

  @override
  List<Object?> get props => [];
}

class SignedInWithAppleFailed extends AuthState {
  @override
  List<Object?> get props => [];
}