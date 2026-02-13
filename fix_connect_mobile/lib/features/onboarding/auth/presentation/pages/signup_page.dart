import 'package:fix_connect_mobile/app/router/app_navigator.dart';
import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/core/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _textEditingControllerFirstname =
      TextEditingController();
  final TextEditingController _textEditingControllerLastname =
      TextEditingController();
  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final TextEditingController _textEditingControllerPassword =
      TextEditingController();
  final FocusNode _focusNodeFirstname = FocusNode();
  final FocusNode _focusNodeLastname = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool _passwordObscured = true;

  void _togglePasswordObscured() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  @override
  void dispose() {
    _textEditingControllerPassword.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerLastname.dispose();
    _textEditingControllerFirstname.dispose();
    _focusNodeEmail.dispose();
    _focusNodeLastname.dispose();
    _focusNodeFirstname.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  void goBackToLogin() {
    AppNavigator.pushReplacement(AppRoutes.loginPage());
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
                        'Create Account',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      AppGaps.hXs,
                      Text(
                        'Create an account to find trusted experts near you and get your jobs done hassle-free.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      AppGaps.hXl,

                      /// First name
                      InputPrimary(
                        focusNode: _focusNodeFirstname,
                        controller: _textEditingControllerFirstname,
                        autofocus: true,
                        label: 'First name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      AppGaps.hSm,

                      /// Last name
                      InputPrimary(
                        focusNode: _focusNodeLastname,
                        controller: _textEditingControllerLastname,
                        autofocus: true,
                        label: 'Last name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      AppGaps.hSm,

                      /// Email
                      InputPrimary(
                        focusNode: _focusNodeEmail,
                        controller: _textEditingControllerEmail,
                        autofocus: true,
                        label: 'Email',
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
                        label: 'Password',
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

                      AppGaps.hSm,

                      /// Terms and conditions
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By creating an account, you agree to our ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            TextSpan(
                              text: '.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      AppGaps.hLg,

                      /// Sign up button
                      ButtonPrimary(
                        text: 'Create Account',
                        bgColor: Theme.of(context).primaryColor,
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
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: goBackToLogin,
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
