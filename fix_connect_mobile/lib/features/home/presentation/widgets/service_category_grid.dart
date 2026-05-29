import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:fix_connect_mobile/core/widgets/network_svg_icon.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return BlocBuilder<ServicesCubit, ServicesCubitState>(
      builder: (context, state) {
        if (state is ServicesLoading || state is ServicesInitial) {
          return _LoadingGrid(primary: primary);
        }
        if (state is ServicesError) {
          return _ErrorView(
            message: state.message,
            primary: primary,
            textColor: textColor,
            onRetry: () => context.read<ServicesCubit>().load(),
          );
        }
        if (state is ServicesLoaded) {
          // Show first 8 on home screen; rest accessible via "See all".
          final displayed = state.categories.take(8).toList();
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
        return const SizedBox.shrink();
      },
    );
  }
}

// ── Loading shimmer placeholder ───────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  final Color primary;
  const _LoadingGrid({required this.primary});

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
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.custom18),
          ),
        ),
      ),
    );
  }
}

// ── Error view with retry ─────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final Color primary;
  final Color textColor;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.primary,
    required this.textColor,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(
        children: [
          Text(
            'Could not load categories',
            style: AppTextStyles.bodySmallMedium(
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
          AppGaps.h8,
          GestureDetector(
            onTap: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.bodySmallSemibold(color: primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category item with tap animation ─────────────────────────────────────────

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
          cat: widget.category,
          primary: widget.primary,
          textColor: widget.textColor,
        ),
      ),
    );
  }
}

// ── Tile: icon (network or fallback) + label ──────────────────────────────────

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
          _CategoryIcon(
            iconSvg: cat.iconSvg,
            categoryName: cat.name,
            primary: primary,
          ),
          AppGaps.h4,
          Text(
            cat.name,
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

/// Renders the category icon from an inline SVG string; falls back to a
/// category-appropriate Material icon derived from the category name.
class _CategoryIcon extends StatelessWidget {
  final String? iconSvg;
  final String categoryName;
  final Color primary;

  const _CategoryIcon({
    this.iconSvg,
    required this.categoryName,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (iconSvg != null && iconSvg!.isNotEmpty) {
      return SizedBox(
        width: AppSpacing.custom24,
        height: AppSpacing.custom24,
        child: SvgPicture.string(
          iconSvg!,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
        ),
      );
    }
    return Icon(
      NetworkSvgIcon.iconForCategory(categoryName),
      color: primary,
      size: AppSpacing.custom24,
    );
  }
}
