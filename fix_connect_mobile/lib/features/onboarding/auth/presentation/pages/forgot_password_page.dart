import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:flutter/material.dart';

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
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AppGaps.h24,

              /// Submit button
              ButtonPrimary(
                text: 'Submit',
                bgColor: Theme.of(context).primaryColor,
                enabled: _canSubmit,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
