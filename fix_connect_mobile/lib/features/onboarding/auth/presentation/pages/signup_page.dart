import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/core/widgets/social_icon_button.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/models/otp_args.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final TextEditingController _textEditingControllerPhone =
      TextEditingController();
  final TextEditingController _textEditingControllerPassword =
      TextEditingController();
  final FocusNode _focusNodeFirstname = FocusNode();
  final FocusNode _focusNodeLastname = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool _passwordObscured = true;
  String _selectedRole = 'CUSTOMER';

  bool get _canSignUp =>
      _textEditingControllerFirstname.text.trim().isNotEmpty &&
      _textEditingControllerLastname.text.trim().isNotEmpty &&
      _textEditingControllerEmail.text.trim().isNotEmpty &&
      _textEditingControllerPhone.text.trim().isNotEmpty &&
      _textEditingControllerPassword.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _textEditingControllerFirstname.addListener(() => setState(() {}));
    _textEditingControllerLastname.addListener(() => setState(() {}));
    _textEditingControllerEmail.addListener(() => setState(() {}));
    _textEditingControllerPhone.addListener(() => setState(() {}));
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
    _textEditingControllerPhone.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerLastname.dispose();
    _textEditingControllerFirstname.dispose();
    _focusNodeEmail.dispose();
    _focusNodePhone.dispose();
    _focusNodeLastname.dispose();
    _focusNodeFirstname.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  void goBackToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.of(context).pushNamed(
            AppRoutes.otp,
            arguments: OtpArgs(
              email: state.email,
              source: OtpSource.signup,
              role: _selectedRole == 'ARTISAN'
                  ? UserRole.artisan
                  : UserRole.customer,
            ),
          );
        } else if (state is SignupFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: scheme.error,
              ),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: AppSpacing.custom24,
                      bottom: AppSpacing.custom16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        AppGaps.h4,
                        Text(
                          'Find trusted experts or offer your skills.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        AppGaps.h24,

                        /// Role cards
                        Text(
                          'I am a…',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        AppGaps.h8,
                        Row(
                          children: [
                            _RoleCard(
                              icon: Icons.person_search_rounded,
                              title: 'Customer',
                              subtitle: 'I need a pro',
                              selected: _selectedRole == 'CUSTOMER',
                              onTap: () =>
                                  setState(() => _selectedRole = 'CUSTOMER'),
                              primary: primary,
                              scheme: scheme,
                            ),
                            SizedBox(width: AppSpacing.custom16),
                            _RoleCard(
                              icon: Icons.construction_rounded,
                              title: 'Artisan',
                              subtitle: 'I fix things',
                              selected: _selectedRole == 'ARTISAN',
                              onTap: () =>
                                  setState(() => _selectedRole = 'ARTISAN'),
                              primary: primary,
                              scheme: scheme,
                            ),
                          ],
                        ),

                        AppGaps.h16,

                        /// Name row
                        Row(
                          children: [
                            Expanded(
                              child: InputPrimary(
                                focusNode: _focusNodeFirstname,
                                controller: _textEditingControllerFirstname,
                                autofocus: true,
                                label: 'First name',
                              ),
                            ),
                            SizedBox(width: AppSpacing.custom16),
                            Expanded(
                              child: InputPrimary(
                                focusNode: _focusNodeLastname,
                                controller: _textEditingControllerLastname,
                                label: 'Last name',
                              ),
                            ),
                          ],
                        ),

                        AppGaps.h10,

                        /// Email
                        InputPrimary(
                          focusNode: _focusNodeEmail,
                          controller: _textEditingControllerEmail,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: scheme.primary,
                          ),
                        ),

                        AppGaps.h10,

                        /// Phone
                        InputPrimary(
                          focusNode: _focusNodePhone,
                          controller: _textEditingControllerPhone,
                          label: 'Phone number',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: scheme.primary,
                          ),
                        ),

                        AppGaps.h10,

                        /// Password
                        InputPrimary(
                          obscureText: _passwordObscured,
                          focusNode: _focusNodePassword,
                          controller: _textEditingControllerPassword,
                          label: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: scheme.primary,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: AppSpacing.custom4),
                            child: GestureDetector(
                              onTap: _togglePasswordObscured,
                              child: Icon(
                                _passwordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: AppSpacing.custom24,
                              ),
                            ),
                          ),
                        ),

                        AppGaps.h24,

                        /// Create Account button
                        BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) => ButtonPrimary(
                            enabled: _canSignUp && state is! SignupLoading,
                            isLoading: state is SignupLoading,
                            text: 'Create Account',
                            bgColor: primary,
                            onTap: () => context.read<SignupBloc>().add(
                              SignupSubmitted(
                                firstName: _textEditingControllerFirstname.text
                                    .trim(),
                                lastName: _textEditingControllerLastname.text
                                    .trim(),
                                email: _textEditingControllerEmail.text.trim(),
                                phone: _textEditingControllerPhone.text.trim(),
                                password: _textEditingControllerPassword.text,
                                role: _selectedRole,
                              ),
                            ),
                          ),
                        ),

                        AppGaps.h16,

                        /// Terms
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'By creating an account you agree to our ',
                              style: Theme.of(context).textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: 'Terms',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: primary),
                                ),
                                TextSpan(
                                  text: ' & ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: primary),
                                ),
                              ],
                            ),
                          ),
                        ),

                        AppGaps.h24,

                        /// Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.custom16,
                              ),
                              child: Text(
                                'or',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        AppGaps.h16,

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
                              asset: ImageAssets.apple(color: Colors.white),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// Sign in link
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.custom8),
                  child: Row(
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: primary),
                        ),
                      ),
                    ],
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

// ── Role card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.primary,
    required this.scheme,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(
              color: selected ? primary : scheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected ? primary : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? Colors.white : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected ? primary : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, size: 18, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}
