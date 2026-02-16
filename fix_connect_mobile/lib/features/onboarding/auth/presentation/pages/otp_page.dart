import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

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

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// get signature code
  _getSignatureCode() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppGaps.hMd,
                Text(
                  'Verify Code',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                AppGaps.hSm,
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
                AppGaps.hLg,
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFieldPin(
                        textController: textEditingController,
                        autoFocus: true,
                        codeLength: _otpCodeLength,
                        alignment: MainAxisAlignment.center,
                        defaultBoxSize: 46.0,
                        margin: 10,
                        selectedBoxSize: 46.0,
                        textStyle: TextStyle(fontSize: 16),
                        defaultDecoration: _pinPutDecoration.copyWith(
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.6),
                          ),
                        ),
                        selectedDecoration: _pinPutDecoration,
                        onChange: (code) {},
                      ),
                    ],
                  ),
                ),

                AppGaps.hMd,
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
                AppGaps.hLg,
                ButtonPrimary(
                  text: 'Submit',
                  bgColor: Theme.of(context).primaryColor,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
