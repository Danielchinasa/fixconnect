import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/home_filter.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan_list_tile.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/empty_search_result.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/filter_sheet.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/home_search_bar.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/how_it_works.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/location_picker_sheet.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/promo_banner_carousel.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/section_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_category_grid.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/stats_strip.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/top_artisans_section.dart';
import 'package:flutter/material.dart';

// 📚 CONCEPT: Widget Extraction / Decomposition
// The HomeTab is carved out of the original HomePage so the shell (HomePage)
// can focus only on navigation. HomeTab handles all the home-specific state
// and UI independently. Each tab lives in its own class — easy to find, test,
// and change without touching anything else.
class HomeTab extends StatefulWidget {
  final VoidCallback? onSeeAllServices;

  const HomeTab({super.key, this.onSeeAllServices});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selectedLocation = 'Lagos, Nigeria';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  HomeFilter _filter = HomeFilter.empty;

  final List<ArtisanModel> _artisans = HomeMockDatasource.getTopArtisans();
  final List<String> _locations = HomeMockDatasource.getLocations();

  bool get _isSearching => _searchQuery.isNotEmpty || _filter.isActive;

  List<ArtisanModel> get _filteredArtisans {
    return _artisans.where((a) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          a.name.toLowerCase().contains(query) ||
          a.specialty.toLowerCase().contains(query);
      final matchesCategory =
          _filter.category == null ||
          a.specialty.toLowerCase().contains(_filter.category!.toLowerCase());
      final matchesRating = a.rating >= _filter.minRating;
      final matchesVerified = !_filter.verifiedOnly || a.isVerified;
      return matchesQuery &&
          matchesCategory &&
          matchesRating &&
          matchesVerified;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final primary = theme.colorScheme.primary;

    // 📚 CONCEPT: CustomScrollView + Slivers
    // A CustomScrollView lets you mix scrollable "slivers" (slices of scroll) —
    // headers, lists, grids — all sharing one scroll controller.
    // SliverToBoxAdapter wraps a regular (non-sliver) widget so it can live
    // inside a CustomScrollView.
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              location: _selectedLocation,
              onLocationTap: _showLocationPicker,
              textColor: textColor,
              primary: primary,
              isDark: isDark,
            ),
          ),
          SliverToBoxAdapter(
            child: HomeSearchBar(
              controller: _searchController,
              surfaceColor: surfaceColor,
              textColor: textColor,
              primary: primary,
              hasText: _searchQuery.isNotEmpty,
              hasActiveFilter: _filter.isActive,
              onChanged: (q) => setState(() => _searchQuery = q),
              onFilterTap: _showFilterSheet,
            ),
          ),
          SliverToBoxAdapter(child: AppGaps.h24),
          SliverToBoxAdapter(
            child: StatsStrip(
              primary: primary,
              textColor: textColor,
              surfaceColor: surfaceColor,
            ),
          ),
          if (!_isSearching) ...[
            SliverToBoxAdapter(child: AppGaps.h24),
            SliverToBoxAdapter(
              child: PromoBannerCarousel(primary: primary, isDark: isDark),
            ),
            SliverToBoxAdapter(child: AppGaps.h24),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'What do you need fixed?',
                actionLabel: 'See all',
                onAction: () => widget.onSeeAllServices?.call(),
                textColor: textColor,
                primary: primary,
              ),
            ),
            SliverToBoxAdapter(child: AppGaps.h8),
            SliverToBoxAdapter(
              child: ServiceCategoryGrid(
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                isDark: isDark,
              ),
            ),
          ],
          SliverToBoxAdapter(child: AppGaps.h24),
          if (_isSearching)
            ..._buildSearchResults(textColor, surfaceColor, primary)
          else
            ..._buildHomeContent(textColor, surfaceColor, primary, isDark),
          // Extra bottom padding so content doesn't hide behind the nav bar.
          // 📚 CONCEPT: MediaQuery.of(context).padding.bottom gives the safe-area
          // inset (the notch/home indicator). We add 80 for the nav bar height.
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResults(
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
    final results = _filteredArtisans;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '${results.length} result${results.length == 1 ? '' : 's'} found',
                style: AppTextStyles.bodyLargeBold(color: textColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _clearSearch,
                child: Text(
                  'Clear all',
                  style: AppTextStyles.bodyMediumSemibold(color: primary),
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: AppGaps.h8),
      if (results.isEmpty)
        SliverToBoxAdapter(
          child: EmptySearchResult(
            query: _searchQuery,
            textColor: textColor,
            primary: primary,
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArtisanListTile(
              artisan: results[index],
              surfaceColor: surfaceColor,
              textColor: textColor,
              primary: primary,
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.artisanProfile, arguments: results[index]),
            ),
            childCount: results.length,
          ),
        ),
    ];
  }

  List<Widget> _buildHomeContent(
    Color textColor,
    Color surfaceColor,
    Color primary,
    bool isDark,
  ) {
    return [
      SliverToBoxAdapter(
        child: SectionHeader(
          title: 'Top-Rated Artisans',
          actionLabel: 'View all',
          onAction: () {},
          textColor: textColor,
          primary: primary,
        ),
      ),
      SliverToBoxAdapter(child: AppGaps.h8),
      SliverToBoxAdapter(
        child: TopArtisansSection(
          artisans: _artisans,
          surfaceColor: surfaceColor,
          textColor: textColor,
          onArtisanTap: (artisan) => Navigator.of(
            context,
          ).pushNamed(AppRoutes.artisanProfile, arguments: artisan),
          primary: primary,
          isDark: isDark,
        ),
      ),
      SliverToBoxAdapter(child: AppGaps.h24),
      SliverToBoxAdapter(
        child: HowItWorks(
          primary: primary,
          textColor: textColor,
          surfaceColor: surfaceColor,
        ),
      ),
    ];
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _filter = HomeFilter.empty;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.custom24),
        ),
      ),
      builder: (_) => FilterSheet(
        filter: _filter,
        primary: Theme.of(context).colorScheme.primary,
        onApply: (updated) {
          setState(() => _filter = updated);
          Navigator.pop(context);
        },
        onReset: () {
          setState(() => _filter = HomeFilter.empty);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.custom24),
        ),
      ),
      builder: (_) => LocationPickerSheet(
        currentLocation: _selectedLocation,
        locations: _locations,
        onSelect: (loc) {
          setState(() => _selectedLocation = loc);
          Navigator.pop(context);
        },
      ),
    );
  }
}
