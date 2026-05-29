import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/models/otp_args.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.args});

  final OtpArgs args;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int _otpCodeLength = 4;
  String _enteredCode = '';

  void _onSubmit() {
    context.read<OtpBloc>().add(
      OtpSubmitted(email: widget.args.email, code: _enteredCode),
    );
  }

  void _onSuccess(BuildContext context, OtpSuccess state) {
    if (widget.args.source == OtpSource.forgotPassword) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.resetPassword);
    } else if (widget.args.role == UserRole.artisan) {
      // Artisan users must complete their profile before accessing the app.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.artisanSetup,
        (_) => false,
        arguments: state.user,
      );
    } else {
      context.read<AuthCubit>().logIn(state.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.primary;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;

    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          _onSuccess(context, state);
        } else if (state is OtpFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        } else if (state is OtpResendSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text(
                  'Code resent!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
        }
      },
      child: Scaffold(
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
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  AppGaps.h8,
                  Text(
                    'We emailed you the four digit code to',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.args.email,
                    style: AppTextStyles.bodyMediumMedium(color: primary),
                  ),
                  AppGaps.h32,
                  OtpTextField(
                    numberOfFields: _otpCodeLength,
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
                    onCodeChanged: (code) =>
                        setState(() => _enteredCode = code),
                    onSubmit: (String verificationCode) {
                      setState(() => _enteredCode = verificationCode);
                    },
                  ),
                  AppGaps.h24,
                  Text(
                    "Didn't receive the code?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  AppGaps.h4,
                  GestureDetector(
                    onTap: () {
                      // TODO: trigger resend OTP API call
                    },
                    child: Text(
                      'Resend Code',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: primary)
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ),

                  AppGaps.h32,
                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) => ButtonPrimary(
                      text: 'Submit',
                      bgColor: primary,
                      isLoading: state is OtpLoading,
                      enabled:
                          _enteredCode.length == _otpCodeLength &&
                          state is! OtpLoading,
                      onTap: _onSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
