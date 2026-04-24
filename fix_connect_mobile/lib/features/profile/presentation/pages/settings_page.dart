import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/section_header.dart';
import 'package:fix_connect_mobile/app/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SettingsPage
// App-wide preferences: appearance, security, language, about.
// ─────────────────────────────────────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometricsEnabled = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.grey500 : AppColors.grey600;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final themeMode = context.watch<ThemeCubit>().state;
    final darkModeOn = themeMode == ThemeMode.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Settings',
            style: AppTextStyles.header4Bold(color: textColor),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(AppSpacing.custom16),
          children: [
            // ── Appearance ──────────────────────────────────────────────────
            SectionHeader(
              title: 'Appearance',
              textColor: textColor,
              primary: primary,
              padding: EdgeInsets.zero,
            ),
            AppGaps.h8,
            _SettingsCard(
              isDark: isDark,
              surfaceColor: surfaceColor,
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  trailing: Transform.scale(
                    scale: 0.85,
                    child: Switch.adaptive(
                      value: darkModeOn,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                      activeColor: primary,
                      inactiveTrackColor: isDark
                          ? AppColors.grey700
                          : AppColors.grey300,
                    ),
                  ),
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  label: 'Language',
                  subtitle: _selectedLanguage,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () => _showLanguagePicker(
                    context,
                    isDark: isDark,
                    textColor: textColor,
                    primary: primary,
                  ),
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
              ],
            ),
            AppGaps.h24,

            // ── Notifications ───────────────────────────────────────────────
            SectionHeader(
              title: 'Notifications',
              textColor: textColor,
              primary: primary,
              padding: EdgeInsets.zero,
            ),
            AppGaps.h8,
            _SettingsCard(
              isDark: isDark,
              surfaceColor: surfaceColor,
              children: [
                _SettingsTile(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email Notifications',
                  trailing: Transform.scale(
                    scale: 0.85,
                    child: Switch.adaptive(
                      value: _emailNotifications,
                      onChanged: (v) => setState(() => _emailNotifications = v),
                      activeColor: primary,
                      inactiveTrackColor: isDark
                          ? AppColors.grey700
                          : AppColors.grey300,
                    ),
                  ),
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.sms_outlined,
                  label: 'SMS Alerts',
                  trailing: Transform.scale(
                    scale: 0.85,
                    child: Switch.adaptive(
                      value: _smsNotifications,
                      onChanged: (v) => setState(() => _smsNotifications = v),
                      activeColor: primary,
                      inactiveTrackColor: isDark
                          ? AppColors.grey700
                          : AppColors.grey300,
                    ),
                  ),
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
              ],
            ),
            AppGaps.h24,

            // ── Security ────────────────────────────────────────────────────
            SectionHeader(
              title: 'Security',
              textColor: textColor,
              primary: primary,
              padding: EdgeInsets.zero,
            ),
            AppGaps.h8,
            _SettingsCard(
              isDark: isDark,
              surfaceColor: surfaceColor,
              children: [
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  label: 'Change Password',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () {},
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  label: 'Biometric Login',
                  subtitle: 'Face ID / Touch ID',
                  trailing: Transform.scale(
                    scale: 0.85,
                    child: Switch.adaptive(
                      value: _biometricsEnabled,
                      onChanged: (v) => setState(() => _biometricsEnabled = v),
                      activeColor: primary,
                      inactiveTrackColor: isDark
                          ? AppColors.grey700
                          : AppColors.grey300,
                    ),
                  ),
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.devices_outlined,
                  label: 'Active Sessions',
                  subtitle: '1 device',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () {},
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
              ],
            ),
            AppGaps.h24,

            // ── About ────────────────────────────────────────────────────────
            SectionHeader(
              title: 'About',
              textColor: textColor,
              primary: primary,
              padding: EdgeInsets.zero,
            ),
            AppGaps.h8,
            _SettingsCard(
              isDark: isDark,
              surfaceColor: surfaceColor,
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  label: 'App Version',
                  subtitle: '1.0.0 (Build 1)',
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.star_outline_rounded,
                  label: 'Rate FixConnect',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () {},
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.share_outlined,
                  label: 'Share with Friends',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () {},
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
                _SettingsDivider(isDark: isDark),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  label: 'Privacy Policy',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  onTap: () {},
                  isDark: isDark,
                  textColor: textColor,
                  subTextColor: subTextColor,
                  primary: primary,
                ),
              ],
            ),
            AppGaps.h32,
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context, {
    required bool isDark,
    required Color textColor,
    required Color primary,
  }) {
    const languages = [
      'English',
      'French',
      'Hausa',
      'Igbo',
      'Yoruba',
      'Pidgin',
    ];
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey700 : AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Language',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 16),
            ...languages.map(
              (lang) => InkWell(
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(ctx);
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang,
                          style: AppTextStyles.bodyMediumMedium(
                            color: textColor,
                          ),
                        ),
                      ),
                      if (_selectedLanguage == lang)
                        Icon(
                          Icons.check_circle_rounded,
                          color: primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.isDark,
    required this.surfaceColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;
  final Color textColor;
  final Color subTextColor;
  final Color primary;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
    required this.textColor,
    required this.subTextColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.custom16),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.custom16,
          vertical: AppSpacing.custom14,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: primary),
            ),
            SizedBox(width: AppSpacing.custom12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMediumMedium(color: textColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmallRegular(
                        color: subTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  final bool isDark;
  const _SettingsDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 1,
        color: isDark
            ? AppColors.grey800.withValues(alpha: 0.6)
            : AppColors.grey200,
      ),
    );
  }
}
