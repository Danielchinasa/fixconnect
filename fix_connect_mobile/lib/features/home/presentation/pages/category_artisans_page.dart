import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/category_artisans_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryArtisansPage extends StatelessWidget {
  final ServiceCategoryModel category;

  const CategoryArtisansPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryArtisansCubit>()..load(category.id),
      child: _CategoryArtisansView(category: category),
    );
  }
}

class _CategoryArtisansView extends StatefulWidget {
  final ServiceCategoryModel category;

  const _CategoryArtisansView({required this.category});

  @override
  State<_CategoryArtisansView> createState() => _CategoryArtisansViewState();
}

class _CategoryArtisansViewState extends State<_CategoryArtisansView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ArtisanModel> _filter(List<ArtisanModel> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.specialty.toLowerCase().contains(q) ||
          a.location.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final primary = context.primary;
    final surfaceColor = context.surfaceColor;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocBuilder<CategoryArtisansCubit, CategoryArtisansState>(
          builder: (context, state) {
            final artisans = state is CategoryArtisansLoaded
                ? _filter(state.artisans)
                : <ArtisanModel>[];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App bar ───────────────────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  backgroundColor: bgColor,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    widget.category.name,
                    style: AppTextStyles.bodyLargeBold(color: textColor),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.custom16,
                        0,
                        AppSpacing.custom16,
                        AppSpacing.custom12,
                      ),
                      child: _SearchBar(
                        controller: _searchController,
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        primary: primary,
                        isDark: isDark,
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    ),
                  ),
                ),

                // ── Loading ───────────────────────────────────────────────
                if (state is CategoryArtisansLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                // ── Error ─────────────────────────────────────────────────
                else if (state is CategoryArtisansError)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.custom24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: textColor.withOpacity(0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              style: AppTextStyles.bodyMediumRegular(
                                color: textColor.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => context
                                  .read<CategoryArtisansCubit>()
                                  .load(widget.category.id),
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
                    ),
                  )
                // ── Results ───────────────────────────────────────────────
                else if (state is CategoryArtisansLoaded) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.custom16,
                        AppSpacing.custom16,
                        AppSpacing.custom16,
                        AppSpacing.custom8,
                      ),
                      child: Text(
                        '${artisans.length} artisan${artisans.length == 1 ? '' : 's'}',
                        style: AppTextStyles.bodySmallRegular(
                          color: textColor.withOpacity(0.55),
                        ),
                      ),
                    ),
                  ),

                  if (artisans.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: textColor.withOpacity(0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No artisans in this category yet'
                                  : 'No artisans found',
                              style: AppTextStyles.bodyMediumSemibold(
                                color: textColor.withOpacity(0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.custom16,
                      ),
                      sliver: SliverList.separated(
                        itemCount: artisans.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final artisan = artisans[i];
                          return _ArtisanListTile(
                            artisan: artisan,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primary: primary,
                            isDark: isDark,
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.artisanProfile,
                              arguments: artisan,
                            ),
                          );
                        },
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 24,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.07),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMediumRegular(color: textColor),
        decoration: InputDecoration(
          hintText: 'Search artisans…',
          hintStyle: AppTextStyles.bodyMediumRegular(
            color: textColor.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18,
            color: textColor.withOpacity(0.4),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ── Artisan list tile ─────────────────────────────────────────────────────────

class _ArtisanListTile extends StatelessWidget {
  final ArtisanModel artisan;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const _ArtisanListTile({
    required this.artisan,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.06);

    final categoryName = artisan.categories.isNotEmpty
        ? artisan.categories.first.name
        : artisan.specialty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar ────────────────────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: artisan.badgeColor.withOpacity(0.12),
                    border: Border.all(
                      color: artisan.badgeColor.withOpacity(0.30),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: artisan.avatarUrl != null
                        ? Image.network(
                            artisan.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(
                                artisan.initials,
                                style: AppTextStyles.bodyLargeBold(
                                  color: artisan.badgeColor,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              artisan.initials,
                              style: AppTextStyles.bodyLargeBold(
                                color: artisan.badgeColor,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: artisan.isOnline
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF9E9E9E),
                      shape: BoxShape.circle,
                      border: Border.all(color: surfaceColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Main info ─────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          artisan.name,
                          style: AppTextStyles.bodyMediumBold(color: textColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (artisan.isVerified)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF22C55E),
                            size: 16,
                          ),
                        ),
                      if (artisan.isFeatured)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB800),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '★ Top',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      categoryName,
                      style: AppTextStyles.bodySmallMedium(color: primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: textColor.withOpacity(0.45),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          artisan.location,
                          style: AppTextStyles.bodySmallRegular(
                            color: textColor.withOpacity(0.55),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── Right: rating + arrow ─────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: artisan.rating > 0
                            ? const Color(0xFFFFB800)
                            : textColor.withOpacity(0.35),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        artisan.rating > 0
                            ? artisan.rating.toStringAsFixed(1)
                            : 'New',
                        style: AppTextStyles.bodySmallSemibold(
                          color: artisan.rating > 0
                              ? const Color(0xFFFFB800)
                              : textColor.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${artisan.reviews} reviews',
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.45),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: textColor.withOpacity(0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
