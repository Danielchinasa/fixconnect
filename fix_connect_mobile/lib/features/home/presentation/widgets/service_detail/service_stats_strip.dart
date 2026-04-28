import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Three-column stat strip (artisans, rating, price) below the hero.
class ServiceStatsStrip extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceStatsStrip({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return Container(
      margin: EdgeInsets.all(AppSpacing.custom16),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.custom16,
        horizontal: AppSpacing.custom8,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.people_rounded,
              value: '${service.artisanCount}+',
              label: 'Artisans',
              primary: primary,
              textColor: textColor,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.star_rounded,
              value: service.avgRating.toStringAsFixed(1),
              label: 'Avg. Rating',
              primary: primary,
              textColor: textColor,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.payments_outlined,
              value: 'From',
              subValue: service.startingPrice,
              label: 'Starting price',
              primary: primary,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2));
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? subValue;
  final String label;
  final Color primary;
  final Color textColor;

  const _StatItem({
    required this.icon,
    required this.value,
    this.subValue,
    required this.label,
    required this.primary,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: primary, size: 22),
        AppGaps.h4,
        if (subValue != null) ...[
          Text(
            value,
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withOpacity(0.5),
            ),
          ),
          Text(
            subValue!,
            style: AppTextStyles.bodyMediumBold(color: textColor),
          ),
        ] else
          Text(value, style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h2,
        Text(
          label,
          style: AppTextStyles.bodySmallRegular(
            color: textColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
