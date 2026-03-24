import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:flutter/material.dart';

class ServiceCategoryGrid extends StatelessWidget {
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;

  const ServiceCategoryGrid({
    super.key,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
  });

  static const _categories = [
    _CategoryData(label: 'Plumbing', icon: Icons.water_drop_outlined),
    _CategoryData(label: 'Electrical', icon: Icons.bolt_rounded),
    _CategoryData(label: 'Carpentry', icon: Icons.handyman_outlined),
    _CategoryData(label: 'Cleaning', icon: Icons.cleaning_services_outlined),
    _CategoryData(label: 'Painting', icon: Icons.format_paint_outlined),
    _CategoryData(label: 'HVAC', icon: Icons.ac_unit_outlined),
    _CategoryData(label: 'Landscaping', icon: Icons.grass_outlined),
    _CategoryData(label: 'Moving', icon: Icons.local_shipping_outlined),
    _CategoryData(label: 'Mechanic', icon: Icons.car_repair_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: IntegerConstants.custom4,
          mainAxisSpacing: AppSpacing.custom12,
          crossAxisSpacing: AppSpacing.custom12,
          childAspectRatio: 0.95,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return _CategoryItem(
            data: cat,
            primary: primary,
            textColor: textColor,
            surfaceColor: surfaceColor,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final _CategoryData data;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.data,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.custom14),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(AppSpacing.custom18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.icon, color: primary, size: AppSpacing.custom24),
            AppGaps.h4,
            Text(
              data.label,
              style: AppTextStyles.bodySmallMedium(color: textColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final String label;
  final IconData icon;
  const _CategoryData({required this.label, required this.icon});
}
