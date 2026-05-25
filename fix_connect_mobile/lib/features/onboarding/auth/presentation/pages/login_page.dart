import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/core/widgets/social_icon_button.dart';
import 'package:flutter/material.dart';

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

  bool get _canLogin =>
      _textEditingControllerEmail.text.trim().isNotEmpty &&
      _textEditingControllerPassword.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _textEditingControllerEmail.addListener(() => setState(() {}));
    _textEditingControllerPassword.addListener(() => setState(() {}));
  }

  void _togglePasswordObscured() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  @override
  void dispose() {
    _textEditingControllerPassword.dispose();
    _textEditingControllerEmail.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  void gotoSignUp() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
  }

  void gotoForgotPasswordPage() {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthCubit>().logIn(state.user);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.custom16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Fix Connect',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        AppGaps.h4,
                        Text(
                          'Hi! Welcome back, you\'ve been missed',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        AppGaps.h32,

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

                        AppGaps.h8,

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
                            padding: EdgeInsets.only(right: AppSpacing.custom4),
                            child: GestureDetector(
                              onTap: _togglePasswordObscured,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: gotoForgotPasswordPage,
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        AppGaps.h24,

                        /// Sign in button
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) => ButtonPrimary(
                            text: 'Sign In',
                            bgColor: Theme.of(context).primaryColor,
                            enabled: _canLogin && state is! LoginLoading,
                            isLoading: state is LoginLoading,
                            onTap: () => context.read<LoginBloc>().add(
                              LoginSubmitted(
                                email: _textEditingControllerEmail.text.trim(),
                                password: _textEditingControllerPassword.text,
                              ),
                            ),
                          ),
                        ),

                        AppGaps.h32,

                        /// Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.custom8,
                              ),
                              child: Text(
                                'Or continue with',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        AppGaps.h32,

                        /// Social buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialIconButton(
                              asset: ImageAssets.google(),
                              onTap: () {},
                            ),
                            SizedBox(width: AppSpacing.custom16),
                            SocialIconButton(
                              asset: ImageAssets.facebook(),
                              onTap: () {},
                            ),
                            SizedBox(width: AppSpacing.custom16),
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
                      onPressed: gotoSignUp,
                      child: Text(
                        'Sign Up',
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
      ),
    );
  }
}
