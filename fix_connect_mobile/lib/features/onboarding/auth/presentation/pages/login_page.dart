import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/theme_cubit.dart';
import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/core/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final TextEditingController _textEditingControllerPassword =
      TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool _passwordObscured = true;
  bool _canUserContinue = false;

  void _togglePasswordObscured() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  void _checkIfUserCanContinue() {
    final password = _textEditingControllerPassword.text.trim();
    setState(() {
      _canUserContinue = password.isNotEmpty && password.length > 7;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingControllerPassword.addListener(_checkIfUserCanContinue);
  }

  @override
  void dispose() {
    _textEditingControllerPassword.dispose();
    _textEditingControllerEmail.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            children: [
              /// 🔹 Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Fix Connect',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      AppGaps.hXs,
                      Text(
                        'Hi! Welcome back, you\'ve been missed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppGaps.hXl,

                      /// Email
                      InputPrimary(
                        focusNode: _focusNodeEmail,
                        controller: _textEditingControllerEmail,
                        autofocus: true,
                        label: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      AppGaps.hSm,

                      /// Password
                      InputPrimary(
                        obscureText: _passwordObscured,
                        focusNode: _focusNodePassword,
                        controller: _textEditingControllerPassword,
                        label: 'Enter your password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: AppSpacing.xs),
                          child: GestureDetector(
                            onTap: _togglePasswordObscured,
                            child: Icon(
                              _passwordObscured
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: AppSpacing.lg,
                            ),
                          ),
                        ),
                      ),

                      AppGaps.hLg,

                      /// Sign in button
                      ButtonPrimary(
                        text: 'Sign In',
                        bgColor: Theme.of(context).primaryColor,
                        enabled: _canUserContinue,
                      ),

                      AppGaps.hXl,

                      /// Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: Text(
                              'Or continue with',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      AppGaps.hXl,

                      /// Social buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIconButton(
                            asset: ImageAssets.google(),
                            onTap: () {},
                          ),
                          SizedBox(width: AppSpacing.md),
                          SocialIconButton(
                            asset: ImageAssets.facebook(),
                            onTap: () {},
                          ),
                          SizedBox(width: AppSpacing.md),
                          SocialIconButton(
                            asset: ImageAssets.apple(),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              /// Theme toggle (optional dev tool)
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
