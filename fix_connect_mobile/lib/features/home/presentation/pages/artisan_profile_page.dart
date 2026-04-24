import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan/artisan_about_section.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan/artisan_booking_bar.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan/artisan_reviews_section.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan/artisan_schedule_card.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan/artisan_work_samples_section.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/avatar_fullscreen_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_hero_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_work_sample_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArtisanProfilePage extends StatefulWidget {
  final ArtisanModel artisan;

  const ArtisanProfilePage({super.key, required this.artisan});

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  late final ScrollController _scrollController;
  bool _isCollapsed = false;

  static const double _collapseOffset = 260.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final collapsed = _scrollController.offset > _collapseOffset;
        if (collapsed != _isCollapsed) setState(() => _isCollapsed = collapsed);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAvatarFullScreen() {
    final artisan = widget.artisan;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => AvatarFullscreenPage(
          artisan: artisan,
          badgeColor: artisan.badgeColor,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final artisan = widget.artisan;
    final reviews = HomeMockDatasource.getReviewsForArtisan(artisan.id);
    final samples = workSamplesForSpecialty(artisan.specialty);
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isCollapsed
            ? (isDark ? Brightness.light : Brightness.dark)
            : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 340.0,
              pinned: true,
              stretch: true,
              elevation: _isCollapsed ? 2 : 0,
              backgroundColor: bgColor,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: _isCollapsed
                  ? Row(
                      children: [
                        Text(
                          artisan.name,
                          style: AppTextStyles.bodyLargeBold(color: textColor),
                        ),
                        if (artisan.isVerified) ...[
                          SizedBox(width: AppSpacing.custom6),
                          Icon(
                            Icons.verified_rounded,
                            color: primary,
                            size: AppSpacing.custom18,
                          ),
                        ],
                      ],
                    )
                  : null,
              leading: Padding(
                padding: EdgeInsets.all(AppSpacing.custom8),
                child: ProfileCircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).pop(),
                  isCollapsed: _isCollapsed,
                  isDark: isDark,
                ),
              ),
              actions: [
                ProfileCircleIconButton(
                  icon: Icons.share_rounded,
                  onTap: () {},
                  isCollapsed: _isCollapsed,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                ProfileCircleIconButton(
                  icon: Icons.bookmark_border_rounded,
                  onTap: () {},
                  isCollapsed: _isCollapsed,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                stretchModes: const [StretchMode.zoomBackground],
                background: ProfileHeroHeader(
                  artisan: artisan,
                  onAvatarTap: _showAvatarFullScreen,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _StatsRow(
                artisan: artisan,
                textColor: textColor,
                surfaceColor: surfaceColor,
                primary: primary,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _InfoRow(
                artisan: artisan,
                textColor: textColor,
                surfaceColor: surfaceColor,
                primary: primary,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(child: ArtisanScheduleCard(artisan: artisan)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(child: ArtisanAboutSection(artisan: artisan)),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: ArtisanWorkSamplesSection(samples: samples),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: ArtisanReviewsSection(artisan: artisan, reviews: reviews),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 100,
              ),
            ),
          ],
        ),
        bottomNavigationBar: ArtisanBookingBar(artisan: artisan),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final ArtisanModel artisan;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;

  const _StatsRow({
    required this.artisan,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom16,
        AppSpacing.custom16,
        0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: ProfileStatCell(
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFFFB800),
                value: artisan.rating.toStringAsFixed(1),
                label: 'Rating',
                textColor: textColor,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: textColor.withOpacity(0.12),
            ),
            Expanded(
              child: ProfileStatCell(
                icon: Icons.handyman_rounded,
                iconColor: primary,
                value: artisan.completedJobs > 0
                    ? '${artisan.completedJobs}'
                    : '–',
                label: 'Jobs Done',
                textColor: textColor,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: textColor.withOpacity(0.12),
            ),
            Expanded(
              child: ProfileStatCell(
                icon: Icons.chat_bubble_rounded,
                iconColor: AppColors.secondary,
                value: '${artisan.reviews}',
                label: 'Reviews',
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info row (Location + Price) ───────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final ArtisanModel artisan;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;

  const _InfoRow({
    required this.artisan,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Row(
        children: [
          Expanded(
            child: ProfileInfoCard(
              icon: Icons.location_on_rounded,
              iconColor: primary,
              label: 'Location',
              value: artisan.location.isNotEmpty
                  ? artisan.location
                  : 'Lagos, Nigeria',
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
          ),
          SizedBox(width: AppSpacing.custom8),
          Expanded(
            child: ProfileInfoCard(
              icon: Icons.payments_rounded,
              iconColor: AppColors.secondary,
              label: 'Starting Price',
              value: artisan.startingPrice,
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
