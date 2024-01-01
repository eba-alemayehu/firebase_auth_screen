import 'package:firebase_auth_screen/src/screens/Login/components/login_form.dart';
import 'package:firebase_auth_screen/src/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_screen/src/constants/constants.dart';
import 'package:firebase_auth_screen/src/constants/responsive.dart';
import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';
import 'components/socal_sign_up.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileSignupScreen(),
          desktop: Row(
            children: [
              const Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // SizedBox(
                    //   width: 450,
                    //   child: SignUpForm(),
                    // ),
                    SizedBox(height: defaultPadding / 2),
                    // SocalSignUp()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children:  [
            // Spacer(),
            // Expanded(
            //   flex: 8,
            //   child: LoginForm(),
            // ),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            // Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
