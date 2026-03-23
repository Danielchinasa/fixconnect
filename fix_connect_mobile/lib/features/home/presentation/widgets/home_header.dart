import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLocationTap;
  final Color textColor;
  final Color primary;
  final bool isDark;

  const HomeHeader({
    super.key,
    required this.location,
    required this.onLocationTap,
    required this.textColor,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.md,
          AppSpacing.pagePadding,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, John!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: onLocationTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: primary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: AppTextStyles.bodyMediumSemibold(
                            color: textColor,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: textColor.withOpacity(0.6),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _IconBtn(
              icon: Icons.notifications_outlined,
              badge: true,
              color: textColor,
              isDark: isDark,
              onTap: () {},
            ),
            SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 20,
                backgroundColor: primary,
                child: Text(
                  'JD',
                  style: AppTextStyles.bodySmallBold(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    this.badge = false,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: surfBg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          if (badge)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
