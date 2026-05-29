import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/services_cubit.dart';
import 'package:fix_connect_mobile/core/widgets/network_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServicesAllPage extends StatefulWidget {
  const ServicesAllPage({super.key});

  @override
  State<ServicesAllPage> createState() => _ServicesAllPageState();
}

class _ServicesAllPageState extends State<ServicesAllPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<ServiceCategoryModel> _filter(List<ServiceCategoryModel> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;

    return BlocBuilder<ServicesCubit, ServicesCubitState>(
      builder: (context, state) {
        final categories = state is ServicesLoaded
            ? state.categories
            : <ServiceCategoryModel>[];
        final displayed = _filter(categories);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Gradient App Bar ────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 170,
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _HeaderBackground(
                    isDark: isDark,
                    primary: primary,
                    textColor: textColor,
                    totalCount: categories.length,
                  ),
                ),
                title: _CollapsedTitle(textColor: textColor),
              ),

              // ── Search Bar ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _SearchBar(
                  controller: _searchController,
                  searchQuery: _searchQuery,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  primary: primary,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),

              SliverToBoxAdapter(child: AppGaps.h16),

              // ── Loading / Error ─────────────────────────────────────────
              if (state is ServicesLoading || state is ServicesInitial)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is ServicesError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Could not load services',
                          style: AppTextStyles.bodyMediumRegular(
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                        AppGaps.h8,
                        GestureDetector(
                          onTap: () => context.read<ServicesCubit>().load(),
                          child: Text(
                            'Retry',
                            style: AppTextStyles.bodyMediumSemibold(
                              color: primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // ── Results count ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.custom16,
                    ),
                    child: Text(
                      '${displayed.length} service${displayed.length == 1 ? '' : 's'} found',
                      style: AppTextStyles.bodySmallMedium(
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: AppGaps.h10),

                // ── Services Grid ─────────────────────────────────────────
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.custom16,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      final cat = displayed[i];
                      return _AnimatedServiceCard(
                        category: cat,
                        index: i,
                        animController: _animController,
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.categoryArtisans, arguments: cat),
                      );
                    }, childCount: displayed.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.88,
                        ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 40,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderBackground extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color textColor;
  final int totalCount;

  const _HeaderBackground({
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkBackground, primary.withOpacity(0.18)]
              : [primary.withOpacity(0.12), primary.withOpacity(0.03)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: primary.withOpacity(isDark ? 0.07 : 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: 10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primary.withOpacity(isDark ? 0.05 : 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.custom16,
                right: AppSpacing.custom16,
                top: AppSpacing.custom48,
                bottom: AppSpacing.custom16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.home_repair_service_rounded,
                          color: primary,
                          size: 22,
                        ),
                      ),
                      AppGaps.w8,
                      Text(
                        'All Services',
                        style: AppTextStyles.h3Heading.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  AppGaps.h4,
                  Text(
                    totalCount > 0
                        ? '$totalCount categories • Find what you need'
                        : 'Find what you need',
                    style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withOpacity(0.55),
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

class _CollapsedTitle extends StatelessWidget {
  final Color textColor;
  const _CollapsedTitle({required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      'All Services',
      style: AppTextStyles.bodyLargeBold(color: textColor),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search Bar
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.searchQuery,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom16,
        AppSpacing.custom16,
        AppSpacing.custom10,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
          border: Border.all(
            color: searchQuery.isNotEmpty
                ? primary.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.bodyMediumRegular(color: textColor),
          decoration: InputDecoration(
            hintText: 'Search services...',
            hintStyle: AppTextStyles.bodyMediumRegular(
              color: textColor.withOpacity(0.38),
            ),
            prefixIcon: Icon(Icons.search_rounded, color: primary, size: 22),
            suffixIcon: searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: onClear,
                    child: Icon(
                      Icons.cancel_rounded,
                      color: textColor.withOpacity(0.4),
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.custom16,
              vertical: AppSpacing.custom14,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Service Card
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedServiceCard extends StatelessWidget {
  final ServiceCategoryModel category;
  final int index;
  final AnimationController animController;
  final VoidCallback onTap;

  const _AnimatedServiceCard({
    required this.category,
    required this.index,
    required this.animController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.06).clamp(0.0, 0.7);
    final animation = CurvedAnimation(
      parent: animController,
      curve: Interval(
        delay,
        (delay + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 30 * (1 - animation.value)),
        child: Opacity(opacity: animation.value.clamp(0.0, 1.0), child: child),
      ),
      child: _ServiceCard(category: category, onTap: onTap),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceCategoryModel category;
  final VoidCallback onTap;

  const _ServiceCard({required this.category, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
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
      child: Hero(
        tag: 'service_card_${cat.id}',
        flightShuttleBuilder: (_, animation, __, ___, ____) {
          return AnimatedBuilder(
            animation: animation,
            builder: (_, __) => _ServiceCardContent(cat: cat),
          );
        },
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: _ServiceCardContent(cat: cat),
        ),
      ),
    );
  }
}

class _ServiceCardContent extends StatelessWidget {
  final ServiceCategoryModel cat;

  const _ServiceCardContent({required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : AppColors.grey200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.22 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.custom16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon bubble
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppSpacing.custom12),
              ),
              child: Center(
                child: _CardIcon(iconSvg: cat.iconSvg, categoryName: cat.name),
              ),
            ),
            const Spacer(),
            // Service name
            Text(
              cat.name,
              style: AppTextStyles.bodyLargeBold(color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (cat.description != null && cat.description!.isNotEmpty) ...[
              AppGaps.h4,
              Text(
                cat.description!,
                style: AppTextStyles.bodySmallRegular(
                  color: textColor.withOpacity(0.55),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
            if ((cat.artisanCount ?? 0) >= 10) ...[
              AppGaps.h4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline_rounded, size: 12, color: primary),
                  const SizedBox(width: 3),
                  Text(
                    '${cat.artisanCount} pros available',
                    style: AppTextStyles.bodySmallMedium(color: primary),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Renders an inline SVG string; falls back to a category-appropriate icon.
class _CardIcon extends StatelessWidget {
  final String? iconSvg;
  final String categoryName;
  const _CardIcon({this.iconSvg, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    if (iconSvg != null && iconSvg!.isNotEmpty) {
      return SizedBox(
        width: 26,
        height: 26,
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
      size: 24,
    );
  }
}
