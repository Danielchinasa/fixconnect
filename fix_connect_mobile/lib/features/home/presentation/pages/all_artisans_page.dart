import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllArtisansPage extends StatefulWidget {
  final List<ArtisanModel> artisans;

  const AllArtisansPage({super.key, required this.artisans});

  @override
  State<AllArtisansPage> createState() => _AllArtisansPageState();
}

class _AllArtisansPageState extends State<AllArtisansPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ArtisanModel> get _filtered {
    if (_searchQuery.isEmpty) return widget.artisans;
    final q = _searchQuery.toLowerCase();
    return widget.artisans.where((a) {
      return a.name.toLowerCase().contains(q) ||
          a.specialty.toLowerCase().contains(q) ||
          a.location.toLowerCase().contains(q) ||
          a.categories.any((c) => c.name.toLowerCase().contains(q));
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

    final results = _filtered;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ───────────────────────────────────────────────────
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
                'Top-Rated Artisans',
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

            // ── Count ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  AppSpacing.custom8,
                ),
                child: Text(
                  '${results.length} artisan${results.length == 1 ? '' : 's'}',
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.55),
                  ),
                ),
              ),
            ),

            // ── List ──────────────────────────────────────────────────────
            if (results.isEmpty)
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
                        'No artisans found',
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
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final artisan = results[i];
                    return _ArtisanListTile(
                      artisan: artisan,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      primary: primary,
                      isDark: isDark,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.artisanProfile, arguments: artisan),
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
                // Online dot
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
                  // Name + verified + featured
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

                  // Category chip
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

                  // Location
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

            // ── Right column: rating + price + arrow ──────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rating
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
                        style: AppTextStyles.bodySmallBold(
                          color: artisan.rating > 0
                              ? const Color(0xFFFFB800)
                              : textColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Reviews count
                if (artisan.reviews > 0)
                  Text(
                    '${artisan.reviews} reviews',
                    style: AppTextStyles.bodySmallRegular(
                      color: textColor.withOpacity(0.45),
                    ),
                  ),

                const SizedBox(height: 6),

                // Starting price
                Text(
                  artisan.startingPrice,
                  style: AppTextStyles.bodySmallSemibold(color: primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'starting',
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.40),
                  ),
                ),
              ],
            ),
          ],
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
          hintText: 'Search by name, skill or location…',
          hintStyle: AppTextStyles.bodyMediumRegular(
            color: textColor.withOpacity(0.4),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: textColor.withOpacity(0.45),
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: textColor.withOpacity(0.45),
                    size: 18,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
