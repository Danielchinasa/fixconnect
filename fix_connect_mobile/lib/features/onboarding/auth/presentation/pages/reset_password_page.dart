import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  final FocusNode _focusPassword = FocusNode();
  final FocusNode _focusConfirm = FocusNode();

  bool _passwordObscured = true;
  bool _confirmObscured = true;

  bool get _canSubmit =>
      _passwordCtrl.text.isNotEmpty && _passwordCtrl.text == _confirmCtrl.text;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _focusPassword.dispose();
    _focusConfirm.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.custom16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppGaps.h16,
              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              AppGaps.h8,
              Text(
                'Enter and confirm your new password',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              AppGaps.h24,
              InputPrimary(
                focusNode: _focusPassword,
                controller: _passwordCtrl,
                autofocus: true,
                label: 'New password',
                obscureText: _passwordObscured,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: AppSpacing.custom4),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _passwordObscured = !_passwordObscured),
                    child: Icon(
                      _passwordObscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: AppSpacing.custom24,
                    ),
                  ),
                ),
              ),
              AppGaps.h8,
              InputPrimary(
                focusNode: _focusConfirm,
                controller: _confirmCtrl,
                label: 'Confirm new password',
                obscureText: _confirmObscured,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: AppSpacing.custom4),
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _confirmObscured = !_confirmObscured),
                    child: Icon(
                      _confirmObscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: AppSpacing.custom24,
                    ),
                  ),
                ),
              ),
              AppGaps.h24,
              ButtonPrimary(
                text: 'Reset Password',
                bgColor: Theme.of(context).primaryColor,
                enabled: _canSubmit,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
