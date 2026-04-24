import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';

/// A card containing a list of [ProfileMenuItem] / [ProfileMenuToggle] items,
/// separated by thin dividers.
class ProfileMenuSection extends StatelessWidget {
  final List<Widget> items;

  const ProfileMenuSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
        ),
        child: Column(
          children: _intersperse(
            items,
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
    );
  }

  static Iterable<Widget> _intersperse(
    List<Widget> items,
    Widget separator,
  ) sync* {
    for (int i = 0; i < items.length; i++) {
      yield items[i];
      if (i < items.length - 1) yield separator;
    }
  }
}

/// A tappable row item inside [ProfileMenuSection].
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;
    final isDark = context.isDark;

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
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? AppColors.grey600 : AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}

/// A toggle (switch) row item inside [ProfileMenuSection].
class ProfileMenuToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileMenuToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final textColor = context.textColor;
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.custom16,
        vertical: AppSpacing.custom10,
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
            child: Text(
              label,
              style: AppTextStyles.bodyMediumMedium(color: textColor),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: primary,
              inactiveTrackColor: isDark
                  ? AppColors.grey700
                  : AppColors.grey300,
            ),
          ),
        ],
      ),
    );
  }
}
