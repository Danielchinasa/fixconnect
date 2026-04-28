import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
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
  TextEditingController textEditingController = TextEditingController(text: '');
  String _enteredCode = '';

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {}

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.primary;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
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
                  style: AppTextStyles.header4Bold(
                    color: textColor,
                  ).copyWith(fontSize: 26),
                  textAlign: TextAlign.center,
                ),
                AppGaps.h8,
                Text(
                  'We emailed you the four digit code to',
                  style: AppTextStyles.bodyMediumRegular(
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  'sample@example.com',
                  style: AppTextStyles.bodyMediumMedium(color: primary),
                ),
                AppGaps.h32,
                OtpTextField(
                  numberOfFields: _otpCodeLength,
                  // Box style — clearly visible on any background
                  showFieldAsBox: true,
                  filled: true,
                  fillColor: surfaceColor,
                  borderColor: isDark ? AppColors.grey700 : AppColors.grey300,
                  focusedBorderColor: primary,
                  enabledBorderColor: isDark
                      ? AppColors.grey700
                      : AppColors.grey300,
                  borderWidth: 1.5,
                  fieldWidth: 64,
                  fieldHeight: 64,
                  borderRadius: BorderRadius.circular(14),
                  cursorColor: primary,
                  textStyle: AppTextStyles.header4Bold(
                    color: textColor,
                  ).copyWith(fontSize: 24),
                  keyboardType: TextInputType.number,
                  onCodeChanged: (code) => setState(() => _enteredCode = code),
                  onSubmit: (String verificationCode) {
                    setState(() => _enteredCode = verificationCode);
                  },
                ),
                AppGaps.h24,
                Text(
                  "Didn't receive the code?",
                  style: AppTextStyles.bodyMediumRegular(
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
                AppGaps.h4,
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Resend Code',
                    style: AppTextStyles.bodyMediumMedium(color: primary)
                        .copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: primary,
                        ),
                  ),
                ),
                AppGaps.h32,
                ButtonPrimary(
                  text: 'Submit',
                  bgColor: primary,
                  enabled: _enteredCode.length == _otpCodeLength,
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
