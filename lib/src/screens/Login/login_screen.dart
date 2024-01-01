import 'package:firebase_auth_screen/src/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_screen/src/constants/responsive.dart';

import 'package:firebase_auth_screen/src/constants/constants.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: const MobileLoginScreen(),
          desktop: Row(
            children: [
              // const Expanded(
              //   child: LoginScreenTopImage(),
              // ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // const LoginScreenTopImage(),
        SizedBox(height: 80,),
        Text("Login", style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 16,),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 12,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 180,),
      ],
    );
  }
}
