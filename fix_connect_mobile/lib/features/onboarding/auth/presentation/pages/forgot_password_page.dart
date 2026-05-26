import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/models/otp_args.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/forgot_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();

  bool get _canSubmit => _emailCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.of(context).pushNamed(
            AppRoutes.otp,
            arguments: OtpArgs(
              email: state.email,
              source: OtpSource.forgotPassword,
            ),
          );
        } else if (state is ForgotPasswordFailure) {
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
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.custom16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppGaps.h16,
                Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                AppGaps.h8,
                Text(
                  'Enter your email address to reset your password',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppGaps.h24,
                InputPrimary(
                  focusNode: _focusNodeEmail,
                  controller: _emailCtrl,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.mail_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                AppGaps.h24,
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) => ButtonPrimary(
                    text: 'Submit',
                    bgColor: Theme.of(context).primaryColor,
                    isLoading: state is ForgotPasswordLoading,
                    enabled: _canSubmit && state is! ForgotPasswordLoading,
                    onTap: () => context.read<ForgotPasswordBloc>().add(
                      ForgotPasswordSubmitted(email: _emailCtrl.text.trim()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
