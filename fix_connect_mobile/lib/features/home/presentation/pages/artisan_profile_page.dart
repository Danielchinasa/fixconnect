import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/avatar_fullscreen_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_hero_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_review_card.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_work_sample_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ArtisanProfilePage
// ─────────────────────────────────────────────────────────────────────────────
class ArtisanProfilePage extends StatefulWidget {
  final ArtisanModel artisan;

  const ArtisanProfilePage({super.key, required this.artisan});

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  late final ScrollController _scrollController;
  bool _isCollapsed = false;
  bool _isBioExpanded = false;

  // Collapse threshold = expandedHeight(300) - appBarHeight(56) - statusBar(~24)
  static const double _collapseOffset = 260.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final collapsed = _scrollController.offset > _collapseOffset;
        if (collapsed != _isCollapsed) {
          setState(() => _isCollapsed = collapsed);
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final primary = theme.colorScheme.primary;
    final artisan = widget.artisan;
    final reviews = HomeMockDatasource.getReviewsForArtisan(artisan.id);
    final samples = workSamplesForSpecialty(artisan.specialty);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isCollapsed
            ? (isDark ? Brightness.light : Brightness.dark)
            : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(artisan, isDark, primary, textColor),
            SliverToBoxAdapter(
              child: _buildStatsRow(artisan, textColor, surfaceColor, primary),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _buildInfoRow(artisan, textColor, surfaceColor, primary),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _buildScheduleCard(
                artisan,
                textColor,
                surfaceColor,
                primary,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _buildAboutSection(
                artisan,
                textColor,
                surfaceColor,
                primary,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _buildWorkSamplesSection(
                samples,
                textColor,
                surfaceColor,
                primary,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppSpacing.custom16)),
            SliverToBoxAdapter(
              child: _buildReviewsSection(
                artisan,
                reviews,
                textColor,
                surfaceColor,
                primary,
                isDark,
              ),
            ),
            // Bottom bar clearance
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 100,
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBookingBar(artisan, primary, isDark),
      ),
    );
  }

  // ─── Sliver App Bar ──────────────────────────────────────────────────────────
  Widget _buildSliverAppBar(
    ArtisanModel artisan,
    bool isDark,
    Color primary,
    Color textColor,
  ) {
    return SliverAppBar(
      expandedHeight: 340.0,
      pinned: true,
      stretch: true,
      elevation: _isCollapsed ? 2 : 0,
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
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
          onAvatarTap: () => _showAvatarFullScreen(context, artisan),
        ),
      ),
    );
  }

  // ─── Stats Row ───────────────────────────────────────────────────────────────
  Widget _buildStatsRow(
    ArtisanModel artisan,
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
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

  // ─── Info Row (Location + Price) ──────────────────────────────────────────────
  Widget _buildInfoRow(
    ArtisanModel artisan,
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
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

  // ─── Schedule Card ───────────────────────────────────────────────────────────
  Widget _buildScheduleCard(
    ArtisanModel artisan,
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
    final isOpen = artisan.isTodayOpen;
    const openColor = Color(0xFF22C55E);
    const closedColor = Color(0xFF9E9E9E);
    final statusColor = isOpen ? openColor : closedColor;
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayName = dayNames[DateTime.now().weekday - 1];

    // Build open-day rows (compact: day | divider | hours | today badge)
    final openDayRows = <Widget>[
      for (final day in dayNames)
        if (artisan.weeklySchedule[day] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    day,
                    style: AppTextStyles.bodySmallSemibold(
                      color: day == todayName
                          ? primary
                          : textColor.withOpacity(0.65),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 12,
                  color: textColor.withOpacity(0.15),
                ),
                const SizedBox(width: 8),
                Text(
                  artisan.weeklySchedule[day]!,
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.75),
                  ),
                ),
                if (day == todayName) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Today',
                      style: AppTextStyles.bodySmallBold(
                        color: primary,
                      ).copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 18,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Schedule & Availability',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Today's status pill ─────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                ProfilePulseDot(color: statusColor, isActive: isOpen),
                const SizedBox(width: 10),
                Text(
                  isOpen ? 'Open Now' : 'Closed Today',
                  style: AppTextStyles.bodyMediumSemibold(color: statusColor),
                ),
                const SizedBox(width: 10),
                Text(
                  '·',
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    artisan.todayOpenTime.isNotEmpty
                        ? artisan.todayOpenTime
                        : 'Schedule unavailable',
                    style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withOpacity(0.75),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Weekly day strip ────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 15,
                color: textColor.withOpacity(0.5),
              ),
              const SizedBox(width: 6),
              Text(
                'This Week',
                style: AppTextStyles.bodySmallSemibold(
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final day in dayNames)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day[0],
                        style: AppTextStyles.bodySmallMedium(
                          color: day == todayName
                              ? primary
                              : textColor.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: artisan.weeklySchedule[day] != null
                              ? openColor.withOpacity(0.12)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: day == todayName
                              ? Border.all(color: primary, width: 2)
                              : Border.all(
                                  color:
                                      (artisan.weeklySchedule[day] != null
                                              ? openColor
                                              : closedColor)
                                          .withOpacity(0.3),
                                  width: 1,
                                ),
                        ),
                        child: Center(
                          child: Icon(
                            artisan.weeklySchedule[day] != null
                                ? Icons.check_rounded
                                : Icons.close_rounded,
                            size: 13,
                            color: artisan.weeklySchedule[day] != null
                                ? openColor
                                : closedColor.withOpacity(0.45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Open day hours list ─────────────────────────────
          if (openDayRows.isNotEmpty) ...openDayRows,

          const SizedBox(height: 8),
          Divider(color: textColor.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),

          // ── Response time ───────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFFFFB800),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Response Time',
                    style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artisan.responseTime.isNotEmpty
                        ? artisan.responseTime
                        : 'Within 24 hours',
                    style: AppTextStyles.bodyMediumBold(color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── About Section ───────────────────────────────────────────────────────────
  Widget _buildAboutSection(
    ArtisanModel artisan,
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
    final bio = artisan.bio.isNotEmpty
        ? artisan.bio
        : 'Skilled professional ready to help with your needs.';
    final isLong = bio.length > 120;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bio,
            maxLines: _isBioExpanded ? null : 3,
            overflow: _isBioExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: AppTextStyles.bodyMediumRegular(
              color: textColor.withOpacity(0.8),
            ),
          ),
          if (isLong) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _isBioExpanded = !_isBioExpanded),
              child: Text(
                _isBioExpanded ? 'Show less' : 'Read more',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Work Samples ─────────────────────────────────────────────────────────────
  Widget _buildWorkSamplesSection(
    List<WorkSample> samples,
    Color textColor,
    Color surfaceColor,
    Color primary,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    size: 18,
                    color: textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Work Samples',
                    style: AppTextStyles.bodyMediumBold(color: textColor),
                  ),
                ],
              ),
              Text(
                'See all',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: samples.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, i) =>
                ProfileWorkSampleCard(sample: samples[i]),
          ),
        ],
      ),
    );
  }

  // ─── Reviews Section ─────────────────────────────────────────────────────────
  Widget _buildReviewsSection(
    ArtisanModel artisan,
    List reviews,
    Color textColor,
    Color surfaceColor,
    Color primary,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_half_rounded,
                    size: 18,
                    color: textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Reviews',
                    style: AppTextStyles.bodyMediumBold(color: textColor),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${artisan.reviews}',
                      style: AppTextStyles.bodySmallBold(color: primary),
                    ),
                  ),
                ],
              ),
              Text(
                'See all',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Rating summary bar
          Row(
            children: [
              Text(
                artisan.rating.toStringAsFixed(1),
                style: AppTextStyles.h2Heading,
              ),
              SizedBox(width: AppSpacing.custom12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileStarRow(rating: artisan.rating),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${artisan.reviews} reviews',
                    style: AppTextStyles.bodySmallRegular(
                      color: textColor.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ],
          ),

          AppGaps.h16,
          Divider(color: textColor.withOpacity(0.1), height: 1),
          AppGaps.h16,

          // Individual reviews
          ...reviews.asMap().entries.map(
            (entry) => Column(
              children: [
                ProfileReviewCard(
                  review: entry.value,
                  textColor: textColor,
                  isDark: isDark,
                ),
                if (entry.key < reviews.length - 1) ...[
                  const SizedBox(height: 12),
                  Divider(color: textColor.withOpacity(0.08), height: 1),
                  AppGaps.h10,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Avatar Full-Screen ──────────────────────────────────────────────────
  void _showAvatarFullScreen(BuildContext context, ArtisanModel artisan) {
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

  // ─── Booking Bar ─────────────────────────────────────────────────────────────

  Widget _buildBookingBar(ArtisanModel artisan, Color primary, bool isDark) {
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom14,
        AppSpacing.custom16,
        MediaQuery.of(context).padding.bottom + AppSpacing.custom14,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonPrimary(
            text: 'Book Now',
            bgColor: primary,
            onTap: () {},
            trailing: Icon(
              Icons.calendar_month_rounded,
              color: Theme.of(context).colorScheme.surface,
              size: AppSpacing.custom18,
            ),
          ),
          AppGaps.h10,
          ButtonPrimary(
            text: 'Message',
            bgColor: surfaceColor,
            textColor: primary,
            onTap: () {},
            trailing: Icon(
              Icons.chat_bubble_outline_rounded,
              color: primary,
              size: AppSpacing.custom18,
            ),
          ),
        ],
      ),
    );
  }
}
