import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Sticky "Find a Pro" CTA button at the bottom of ServiceDetailPage.
class ServiceBookButton extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceBookButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final isDark = context.isDark;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom12,
        AppSpacing.custom16,
        bottomInset + AppSpacing.custom12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRoutes.searchResults, arguments: service.label),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppSpacing.custom16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.black87 : Colors.white,
                size: 20,
              ),
              AppGaps.w8,
              Text(
                'Find a ${service.label} Pro',
                style: AppTextStyles.bodyLargeSemibold(
                  color: isDark ? Colors.black87 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
