import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingControllerEmail =
        TextEditingController();
    final FocusNode focusNodeEmail = FocusNode();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppGaps.hMd,
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              AppGaps.hSm,
              Text(
                'Enter your email address to reset your password',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              AppGaps.hLg,
              InputPrimary(
                focusNode: focusNodeEmail,
                controller: textEditingControllerEmail,
                label: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              AppGaps.hLg,

              /// Sign in button
              ButtonPrimary(
                text: 'Submit',
                bgColor: Theme.of(context).primaryColor,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
