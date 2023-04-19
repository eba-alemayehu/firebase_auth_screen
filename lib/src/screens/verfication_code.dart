import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_screen/src/blocs/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationCode extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;
  final int? forceResendingToken;
  final void Function(String) onCodeSubmit;

  const VerificationCode({Key? key,
    required this.phoneNumber,
    required this.verificationId,
    this.forceResendingToken, required this.onCodeSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(),
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                SvgPicture.asset(
                  "assets/unlock.svg",
                  alignment: Alignment.center,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3,
                  package: 'firebase_auth_screen',
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Text(
                  "Verification code",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verification code is sent to ${phoneNumber}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 14.0),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Change"))
                  ],
                ),
                const SizedBox(
                  height: 24.0,
                ),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: Theme
                      .of(context)
                      .primaryColor,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  onSubmit: onCodeSubmit,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CountdownTimer(
                  endTime: DateTime
                      .now()
                      .millisecondsSinceEpoch + 1000 * 120,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Did not get verification code?",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption
                                ?.copyWith(fontSize: 14.0),
                          ),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return TextButton(
                                  onPressed: () {
                                    final authCubit =
                                    BlocProvider.of<AuthCubit>(context);
                                    authCubit.sendPhoneVerificationCode(
                                        phoneNumber,
                                        onCodeSent:
                                            (verificationId, resendId) {},
                                        resendToken: forceResendingToken);
                                    authCubit.stream.listen((state) {
                                      if (state is SendingPhoneConfirmation) {
                                        EasyLoading.showInfo("Resending...");
                                      } else if (state
                                      is ConfirmationCodeSent) {
                                        EasyLoading.showSuccess(
                                            "Verification code sent again");
                                      }
                                    });
                                  },
                                  child: (state is SendingPhoneConfirmation)
                                      ? const SizedBox(
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ))
                                      : const Text('Resend'));
                            },
                          )
                        ],
                      );
                    }
                    return Text(
                        'You can resend confirmation code in ${time.min
                            ?.toString().padLeft(2, '0') ?? '00'}:${time.sec
                            ?.toString().padLeft(2, '0') ?? '00'}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            ?.copyWith(fontSize: 14.0));
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}