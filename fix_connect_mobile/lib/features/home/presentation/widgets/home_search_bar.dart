import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final bool hasText;
  final bool hasActiveFilter;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.hasText,
    required this.hasActiveFilter,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppSpacing.custom52,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: AppTextStyles.bodyMediumRegular(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search services or artisans…',
                  hintStyle: AppTextStyles.bodyMediumRegular(
                    color: textColor.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: primary,
                    size: AppSpacing.custom22,
                  ),
                  suffixIcon: hasText
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: textColor.withOpacity(0.5),
                            size: AppSpacing.custom22,
                          ),
                          onPressed: () {
                            controller.clear();
                            onChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: AppSpacing.custom52,
              height: AppSpacing.custom52,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: Theme.of(context).colorScheme.surface,
                    size: AppSpacing.custom22,
                  ),
                  if (hasActiveFilter)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
