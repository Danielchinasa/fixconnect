import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/services_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final categories = ServicesMockDatasource.getCategories();
    // Show first 8 on home (last one accessible via "See all")
    final displayed = categories.take(8).toList();

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
        itemCount: displayed.length,
        itemBuilder: (context, index) {
          final cat = displayed[index];
          return _CategoryItem(
            category: cat,
            primary: primary,
            textColor: textColor,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.serviceDetail, arguments: cat),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final ServiceCategoryModel category;
  final Color primary;
  final Color textColor;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.primary,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: _CategoryTile(
          cat: cat,
          primary: widget.primary,
          textColor: widget.textColor,
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ServiceCategoryModel cat;
  final Color primary;
  final Color textColor;
  const _CategoryTile({
    required this.cat,
    required this.primary,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.custom14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.custom18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cat.icon, color: primary, size: AppSpacing.custom24),
          AppGaps.h4,
          Text(
            cat.label,
            style: AppTextStyles.bodySmallMedium(color: textColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
