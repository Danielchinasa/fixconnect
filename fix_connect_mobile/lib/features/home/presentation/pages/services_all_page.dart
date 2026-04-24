import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/services_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

class ServicesAllPage extends StatefulWidget {
  const ServicesAllPage({super.key});

  @override
  State<ServicesAllPage> createState() => _ServicesAllPageState();
}

class _ServicesAllPageState extends State<ServicesAllPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;
  late AnimationController _animController;

  static const _filters = ['All', 'Popular', 'Budget', 'Top-Rated'];

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

  List<ServiceCategoryModel> get _filteredCategories {
    final all = ServicesMockDatasource.getCategories();
    var filtered = all.where((c) {
      final q = _searchQuery.toLowerCase();
      return q.isEmpty || c.label.toLowerCase().contains(q);
    }).toList();

    switch (_selectedFilter) {
      case 1: // Popular
        filtered.sort((a, b) => b.artisanCount.compareTo(a.artisanCount));
      case 2: // Budget
        filtered.sort((a, b) {
          final aVal =
              int.tryParse(a.startingPrice.replaceAll(RegExp(r'[^\d]'), '')) ??
              0;
          final bVal =
              int.tryParse(b.startingPrice.replaceAll(RegExp(r'[^\d]'), '')) ??
              0;
          return aVal.compareTo(bVal);
        });
      case 3: // Top-Rated
        filtered.sort((a, b) => b.avgRating.compareTo(a.avgRating));
    }
    return filtered;
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Gradient App Bar ──────────────────────────────────────────────
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
                totalCount: ServicesMockDatasource.getCategories().length,
              ),
            ),
            title: _CollapsedTitle(textColor: textColor),
          ),

          // ── Search Bar ────────────────────────────────────────────────────
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

          // ── Filter Chips ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FilterChips(
              filters: _filters,
              selected: _selectedFilter,
              primary: primary,
              surfaceColor: surfaceColor,
              textColor: textColor,
              isDark: isDark,
              onSelect: (i) => setState(() => _selectedFilter = i),
            ),
          ),

          SliverToBoxAdapter(child: AppGaps.h16),

          // ── Results count ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
              child: Text(
                '${_filteredCategories.length} service${_filteredCategories.length == 1 ? '' : 's'} found',
                style: AppTextStyles.bodySmallMedium(
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: AppGaps.h10),

          // ── Services Grid ─────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, i) {
                final cat = _filteredCategories[i];
                return _AnimatedServiceCard(
                  category: cat,
                  index: i,
                  animController: _animController,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.serviceDetail, arguments: cat),
                );
              }, childCount: _filteredCategories.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
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
          // Decorative blobs
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
                    '$totalCount categories • Find what you need',
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

class _FilterChips extends StatelessWidget {
  final List<String> filters;
  final int selected;
  final Color primary;
  final Color surfaceColor;
  final Color textColor;
  final bool isDark;
  final ValueChanged<int> onSelect;

  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.primary,
    required this.surfaceColor,
    required this.textColor,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
        separatorBuilder: (_, __) => AppGaps.w8,
        itemCount: filters.length,
        itemBuilder: (context, i) {
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.custom16,
                vertical: AppSpacing.custom8,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [primary, primary.withOpacity(0.75)],
                      )
                    : null,
                color: isSelected ? null : surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.custom24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (i == 1) ...[
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 13,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 3),
                  ],
                  if (i == 2) ...[
                    Icon(
                      Icons.savings_outlined,
                      size: 13,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 3),
                  ],
                  if (i == 3) ...[
                    Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : textColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 3),
                  ],
                  Text(
                    filters[i],
                    style: AppTextStyles.bodySmallSemibold(
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : textColor.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cat.gradientColors,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        boxShadow: [
          BoxShadow(
            color: cat.gradientColors.first.withOpacity(0.38),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circles
          Positioned(
            right: -22,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 40,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(AppSpacing.custom16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon bubble
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(AppSpacing.custom14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(cat.icon, color: Colors.white, size: 28),
                ),

                const Spacer(),

                // Service name
                Text(
                  cat.label,
                  style: AppTextStyles.bodyLargeBold(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppGaps.h4,

                // Artisan count
                Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${cat.artisanCount} artisans',
                      style: AppTextStyles.bodySmallRegular(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),

                AppGaps.h8,

                // Rating + Price row
                Row(
                  children: [
                    // Rating badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cat.avgRating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmallSemibold(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Starting price
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat.startingPrice,
                        style: AppTextStyles.bodySmallMedium(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
