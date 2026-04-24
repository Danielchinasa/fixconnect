import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int _otpCodeLength = 4;
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.custom16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppGaps.h16,
                Text(
                  'Verify Code',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                AppGaps.h8,
                Text(
                  'We emailed you the six digit code to',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'sample@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                AppGaps.h24,
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OtpTextField(
                        numberOfFields: _otpCodeLength,
                        borderColor: Theme.of(context).primaryColor,
                        focusedBorderColor: Theme.of(context).primaryColor,
                        showFieldAsBox: false,
                        borderWidth: 1.0,
                        fieldWidth: 50,
                        fieldHeight: 50,
                        borderRadius: BorderRadius.circular(15.0),
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        onSubmit: (String verificationCode) {
                          // Handle OTP submission
                          print('OTP is => $verificationCode');
                        },
                      ),
                    ],
                  ),
                ),

                AppGaps.h16,
                Text(
                  'Didn\'t receive the code?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Resend Code',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
                AppGaps.h24,
                ButtonPrimary(
                  text: 'Submit',
                  bgColor: Theme.of(context).primaryColor,
                  onTap: () {
                    context.read<AuthCubit>().logIn();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
