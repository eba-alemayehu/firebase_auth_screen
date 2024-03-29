import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_screen/src/blocs/auth/auth_cubit.dart';
import 'package:firebase_auth_screen/src/constants/size.dart';
import 'package:firebase_auth_screen/src/screens/Login/login_screen.dart';
import 'package:firebase_auth_screen/src/screens/verfication_code.dart';
import 'package:firebase_auth_screen/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sign_button/sign_button.dart' as sign_button_mini;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../blocs/auth/auth_cubit.dart';

enum ButtonsAlignment { VERTICAL, HORIZONTAL }

typedef Authenticated = void Function(
  User? user,
);

class LoginScreen extends StatelessWidget {
  final ImageProvider? decorationImage;
  final Widget? title;
  final ButtonsAlignment? alignment;
  final Authenticated onAuthenticated;
  final bool facebook;
  final bool google;
  final bool apple;
  final bool phone;
  final bool password;
  final double marginTopRatio;

  const LoginScreen(
      {Key? key,
      this.decorationImage,
      this.title,
      required this.onAuthenticated,
      this.marginTopRatio = 0.15,
      this.alignment = ButtonsAlignment.HORIZONTAL,
      this.facebook = false,
      this.google = false,
      this.password = false,
      this.apple = false,
      this.phone = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Body(
        marginTopRatio: this.marginTopRatio,
        facebook: facebook,
        google: google,
        apple: apple,
        phone: phone,
        decorationImage: decorationImage,
        title: title,
        password: password,
        onAuthenticated: onAuthenticated,
        alignment: alignment,
      ),
    );
  }
}

class Body extends StatefulWidget {
  final ImageProvider? decorationImage;
  final Widget? title;
  final ButtonsAlignment? alignment;
  final Authenticated onAuthenticated;
  final bool facebook;
  final bool google;
  final bool apple;
  final bool phone;
  final bool password;
  final double marginTopRatio;

  const Body(
      {Key? key,
      this.decorationImage,
      this.title,
      required this.onAuthenticated,
      this.marginTopRatio = 0.15,
      this.alignment = ButtonsAlignment.HORIZONTAL,
      this.password = false,
      this.facebook = false,
      this.google = false,
      this.apple = false,
      this.phone = true})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    BlocProvider.of<AuthCubit>(context).stream.listen((state) {
      if (state is SignedIn) {
        widget.onAuthenticated(state.user);
        EasyLoading.dismiss();
      } else if (state is SignInFailed) {
        EasyLoading.dismiss();
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: state.error?.toString() ?? 'Unknown error occurred.',
          ),
        );
      } else if (state is SigningIn) {
        EasyLoading.show();
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * widget.marginTopRatio,
          ),
          if (widget.title != null) Container(child: widget.title),
          if (widget.phone) VERTICAL_MARGIN_5,
          if (widget.phone) PhoneInput(),
          if (widget.phone) VERTICAL_MARGIN_7,
          if ((widget.apple || widget.google || widget.facebook) &&
              widget.phone)
            const Center(
              child: Text("Sign in with"),
            ),
          if (widget.alignment == ButtonsAlignment.HORIZONTAL)
            Column(
              children: [
                VERTICAL_MARGIN_7,
                HorizontalSocialSignInButton(
                  facebook: widget.facebook,
                  google: widget.google,
                  apple: widget.apple,
                )
              ],
            ),
          VERTICAL_MARGIN_5,
          if (widget.alignment == ButtonsAlignment.VERTICAL)
            VerticalSocialSignInButton(
              password: widget.password,
              facebook: widget.facebook,
              google: widget.google,
              apple: widget.apple,
            ),
        ],
      ),
    );
  }

  @override
  void codeUpdated() {
    // TODO: implement codeUpdated
    print("Code: updated");
  }
}

class VerticalSocialSignInButton extends StatelessWidget {
  final bool facebook;
  final bool google;
  final bool apple;
  final bool password;

  const VerticalSocialSignInButton(
      {Key? key,
      this.password = false,
      this.facebook = false,
      this.google = false,
      this.apple = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (google)
            SocialLoginButton(
              buttonType: SocialLoginButtonType.google,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithGoogle();
              },
            ),
          // SignInButton(
          //   Buttons.Google,
          //   onPressed: () {
          //     BlocProvider.of<AuthCubit>(context).signInWithGoogle();
          //   },
          //   elevation: 0,
          //   padding: EdgeInsets.all(8.0),
          // ),
          if (google)
            const SizedBox(
              height: 16.0,
            ),
          if (apple)
            SocialLoginButton(
              buttonType: SocialLoginButtonType.apple,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithApple();
              },
            ),
          if (apple)
            const SizedBox(
              height: 16.0,
            ),
          if (facebook)
            SocialLoginButton(
              buttonType: SocialLoginButtonType.facebook,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithFacebook();
              },
            ),
          if (password)
            SocialLoginButton(
              backgroundColor: Colors.white,
              textColor: Theme.of(context).textTheme.titleLarge!.color,
              height: 50,
              text: 'Sign in with Email',
              borderRadius: 5,
              fontSize: 16,
              buttonType: SocialLoginButtonType.generalLogin,
              imageURL: "assets/icons/email-icon.png",
              onPressed: () async {
                final signIn = await showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return const SignInScreen();
                    });
                if(signIn) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
        ],
      ),
    );
  }
}

class HorizontalSocialSignInButton extends StatelessWidget {
  final bool facebook;
  final bool google;
  final bool apple;

  const HorizontalSocialSignInButton(
      {Key? key,
      this.facebook = false,
      this.google = false,
      this.apple = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (google)
            sign_button_mini.SignInButton.mini(
              padding: 12,
              buttonType: sign_button_mini.ButtonType.google,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithGoogle();
              },
              elevation: 1,
            ),
          if (apple)
            sign_button_mini.SignInButton.mini(
              padding: 12,
              buttonType: sign_button_mini.ButtonType.apple,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithApple();
              },
              elevation: 1,
            ),
          if (facebook)
            sign_button_mini.SignInButton.mini(
              padding: 12,
              buttonType: sign_button_mini.ButtonType.facebook,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithFacebook();
              },
              elevation: 1,
            ),
        ],
      ),
    );
  }
}

class PhoneInput extends StatefulWidget {
  PhoneInput({Key? key}) : super(key: key);
  PhoneNumber? phoneNumber;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> with CodeAutoFill {
  String? verificationId;
  bool isValidated = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 12,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: InternationalPhoneNumberInput(
                countries: ["ET", "US"],
                onInputChanged: (PhoneNumber value) {
                  widget.phoneNumber = value;
                },
                onInputValidated: (isValid) => setState(() {
                  isValidated = isValid;
                }),
                inputDecoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  border: InputBorder.none,
                  filled: true,
                ),
                autoValidateMode: AutovalidateMode.disabled,
                spaceBetweenSelectorAndTextField: 0,
                selectorConfig: const SelectorConfig(
                    leadingPadding: 0, trailingSpace: false),
              ),
            ),
          ),
          HORIZONTAL_MARGIN_3,
          Button(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(32.0),
            padding: const EdgeInsets.all(4.0),
            onPressed: !isValidated
                ? null
                : () async {
                    if (widget.phoneNumber != null) {
                      BlocProvider.of<AuthCubit>(context)
                          .stream
                          .listen((state) => {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(state.toString()),
                                ))
                              });
                      final String phone =
                          widget.phoneNumber?.phoneNumber ?? '';
                      BlocProvider.of<AuthCubit>(context)
                          .sendPhoneVerificationCode(
                              widget.phoneNumber?.phoneNumber?.toString() ?? '',
                              onCodeSent: (
                        String verificationId,
                        int? forceResendingToken,
                      ) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Verification code is sent"),
                        ));
                        this.verificationId = verificationId;
                        _showPhoneVerificationModal(context, verificationId,
                            forceResendingToken, phone);
                      });
                    }
                  },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is SendingPhoneConfirmation) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  );
                }
                return const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showPhoneVerificationModal(
      cxt, String verificationId, int? forceResendingToken, String phone) {
    if (phone == null) {
      Fluttertoast.showToast(
          msg: "Phone number is required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    showMaterialModalBottomSheet(
      context: cxt,
      builder: (context) => BlocProvider(
        create: (context) => BlocProvider.of<AuthCubit>(cxt),
        child: VerificationCode(
          phoneNumber: phone,
          verificationId: verificationId,
          forceResendingToken: forceResendingToken,
          onCodeSubmit: (code) => {_verifyCode(verificationId, code)},
        ),
      ),
    );
  }

  void _verifyCode(verificationId, verificationCode) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.signInPhoneNumber(verificationId, verificationCode);
    authCubit.stream.listen((state) {
      if (state is SigningInWithPhone) {
        EasyLoading.show();
      } else if (state is SignedInWithPhone) {
        EasyLoading.showSuccess("Signed in");
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      } else if (state is SignedInWithPhoneFailed) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "The sms verification code is invalid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: verificationCode);
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void codeUpdated() {
    _verifyCode(verificationId, code);
  }
}
