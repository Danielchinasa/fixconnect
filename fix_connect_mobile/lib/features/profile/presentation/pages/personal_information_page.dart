import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PersonalInformationPage
// Read-only view of the user's personal details with an Edit button.
// ─────────────────────────────────────────────────────────────────────────────
class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  // Mock data — replace with real user model when backend is ready
  static const _fields = [
    _InfoField(
      icon: Icons.person_outline_rounded,
      label: 'Full Name',
      value: 'Daniel Ochinasa',
    ),
    _InfoField(
      icon: Icons.mail_outline_rounded,
      label: 'Email Address',
      value: 'daniel@fixconnect.app',
    ),
    _InfoField(
      icon: Icons.phone_outlined,
      label: 'Phone Number',
      value: '+234 810 000 0000',
    ),
    _InfoField(
      icon: Icons.cake_outlined,
      label: 'Date of Birth',
      value: '12 March 1994',
    ),
    _InfoField(
      icon: Icons.person_pin_circle_outlined,
      label: 'Gender',
      value: 'Male',
    ),
    _InfoField(
      icon: Icons.location_city_outlined,
      label: 'City',
      value: 'Lagos, Nigeria',
    ),
    _InfoField(
      icon: Icons.notes_rounded,
      label: 'Bio',
      value:
          'Homeowner and DIY enthusiast. I love finding reliable artisans to help maintain my home.',
    ),
  ];

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
            'Personal Information',
            style: AppTextStyles.header4Bold(color: textColor),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.editProfile),
              child: Text(
                'Edit',
                style: AppTextStyles.bodyMediumBold(color: primary),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(AppSpacing.custom16),
          children: [
            // Avatar preview
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withValues(alpha: 0.15),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.35),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'DO',
                      style: AppTextStyles.bodyLargeBold(
                        color: primary,
                      ).copyWith(fontSize: 22),
                    ),
                  ),
                  AppGaps.h8,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: 14, color: primary),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Account',
                        style: AppTextStyles.bodySmallMedium(color: primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppGaps.h24,

            // Info cards
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.custom16),
              ),
              child: Column(
                children: _intersperse(
                  _fields
                      .map(
                        (f) => _InfoRow(
                          field: f,
                          isDark: isDark,
                          textColor: textColor,
                          subTextColor: subTextColor,
                          primary: primary,
                        ),
                      )
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? AppColors.grey800.withValues(alpha: 0.6)
                          : AppColors.grey200,
                    ),
                  ),
                ).toList(),
              ),
            ),
            AppGaps.h24,

            // Edit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.editProfile),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isDark ? AppColors.grey900 : Colors.white,
                ),
                label: Text(
                  'Edit Profile',
                  style: AppTextStyles.bodyMediumBold(
                    color: isDark ? AppColors.grey900 : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            AppGaps.h32,
          ],
        ),
      ),
    );
  }

  static Iterable<Widget> _intersperse(List<Widget> items, Widget sep) sync* {
    for (int i = 0; i < items.length; i++) {
      yield items[i];
      if (i < items.length - 1) yield sep;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final _InfoField field;
  final bool isDark;
  final Color textColor;
  final Color subTextColor;
  final Color primary;

  const _InfoRow({
    required this.field,
    required this.isDark,
    required this.textColor,
    required this.subTextColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.custom16,
        vertical: AppSpacing.custom14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(field.icon, size: 18, color: primary),
          ),
          SizedBox(width: AppSpacing.custom12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: AppTextStyles.bodySmallRegular(color: subTextColor),
                ),
                const SizedBox(height: 3),
                Text(
                  field.value,
                  style: AppTextStyles.bodyMediumMedium(color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Simple data class for an info row
class _InfoField {
  final IconData icon;
  final String label;
  final String value;
  const _InfoField({
    required this.icon,
    required this.label,
    required this.value,
  });
}
