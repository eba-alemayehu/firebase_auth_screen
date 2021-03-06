import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_screen/src/blocs/auth/auth_cubit.dart';
import 'package:firebase_auth_screen/src/constants/size.dart';
import 'package:firebase_auth_screen/src/screens/verfication_code.dart';
import 'package:firebase_auth_screen/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sign_button/sign_button.dart' as sign_button_mini;
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

  const LoginScreen(
      {Key? key,
      this.decorationImage,
      this.title,
      required this.onAuthenticated,
      this.alignment = ButtonsAlignment.HORIZONTAL,
      this.facebook = false,
      this.google = false,
      this.apple = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: Body(
          facebook: facebook,
          google: google,
          apple: apple,
          decorationImage: this.decorationImage,
          title: this.title,
          onAuthenticated: this.onAuthenticated,
          alignment: this.alignment,
        ),
        // bottomNavigationBar: (widget.decorationImage != null)?AspectRatio(
        //   aspectRatio: 9 / 3,
        //   child: Container(
        //     decoration: BoxDecoration(
        //         image: DecorationImage(
        //       fit: BoxFit.fitWidth,
        //       alignment: FractionalOffset.bottomCenter,
        //       image:  widget.decorationImage//AssetImage("assets/images/background_decoration.png"),
        //     )),
        //   ),
        //   // Image.asset("assets/images/background_decoration.png"),
        // ): Container(),
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

  const Body(
      {Key? key,
      this.decorationImage,
      this.title,
      required this.onAuthenticated,
      this.alignment = ButtonsAlignment.HORIZONTAL,
      this.facebook = false,
      this.google = false,
      this.apple = false})
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
      } else if (state is SigningIn){
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
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          if (widget.title != null) Container(child: widget.title),
          VERTICAL_MARGIN_5,
          PhoneInput(),
          VERTICAL_MARGIN_7,
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
              facebook: widget.facebook,
              google: widget.google,
              apple: widget.apple,
            ),
        ],
      ),
    );
  }
}

class VerticalSocialSignInButton extends StatelessWidget {
  final bool facebook;
  final bool google;
  final bool apple;

  const VerticalSocialSignInButton(
      {Key? key,
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
            SignInButton(
              Buttons.Google,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithGoogle();
              },
              elevation: 0,
              padding: EdgeInsets.all(8.0),
            ),
          if (google)
            const SizedBox(
              height: 16.0,
            ),
          if (apple)
            SignInButton(
              Buttons.Apple,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithApple();
              },
              elevation: 0,
              padding: EdgeInsets.all(8.0),
            ),
          if (apple)
            const SizedBox(
              height: 16.0,
            ),
          if (facebook)
            SignInButton(
              Buttons.FacebookNew,
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signInWithFacebook();
              },
              elevation: 0,
              padding: EdgeInsets.all(12.0),
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

class PhoneInput extends StatelessWidget {
  PhoneNumber? phoneNumber;

  PhoneInput({Key? key}) : super(key: key);

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
                countries: ["ET"],
                onInputChanged: (PhoneNumber value) {
                  phoneNumber = value;
                },
                inputDecoration: InputDecoration(
                  fillColor: Theme.of(context).cardColor,
                  border: InputBorder.none,
                  filled: true,
                ),
              ),
            ),
          ),
          HORIZONTAL_MARGIN_3,
          Button(
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(32.0),
            padding: const EdgeInsets.all(4.0),
            onPressed: () async {
              if (phoneNumber != null) {
                BlocProvider.of<AuthCubit>(context).sendPhoneVerificationCode(
                    phoneNumber?.toString() ?? '', onCodeSent: (
                  String verificationId,
                  int? forceResendingToken,
                ) {
                  _showPhoneVerificationModal(
                      context, verificationId, forceResendingToken);
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
      cxt, String verificationId, int? forceResendingToken) {
    showMaterialModalBottomSheet(
      context: cxt,
      builder: (context) => BlocProvider(
        create: (context) => BlocProvider.of<AuthCubit>(cxt),
        child: VerificationCode(
          phoneNumber: phoneNumber.toString(),
          verificationId: verificationId,
          forceResendingToken: forceResendingToken,
        ),
      ),
    );
  }
}
