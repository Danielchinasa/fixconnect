import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Chip list of popular sub-services for a category.
class ServicePopularServices extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServicePopularServices({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0, AppSpacing.custom16, AppSpacing.custom24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          AppGaps.w8,
          Text('Popular Services', style: AppTextStyles.bodyLargeBold(color: textColor)),
        ]),
        AppGaps.h10,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: service.popularServices.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primary.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(s, style: AppTextStyles.bodySmallSemibold(color: primary)),
          )).toList(),
        ),
      ]),
    );
  }
}
