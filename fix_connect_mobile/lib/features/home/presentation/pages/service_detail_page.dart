import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceCategoryModel service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final bgColor = theme.scaffoldBackgroundColor;

    // Filter artisans loosely by service label keyword
    final allArtisans = HomeMockDatasource.getTopArtisans();
    final featured = allArtisans.take(3).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero Gradient App Bar ───────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: service.gradientColors.last,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: _BackButton(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: 'service_card_${service.id}',
                    child: _HeroHeader(service: service),
                  ),
                ),
              ),

              // ── Stats Strip ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _StatsStrip(
                  service: service,
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  primary: primary,
                ),
              ),

              // ── Description ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _DescriptionSection(
                  service: service,
                  textColor: textColor,
                  primary: primary,
                  isDark: isDark,
                ),
              ),

              // ── Popular Services (chips) ─────────────────────────────────
              SliverToBoxAdapter(
                child: _PopularServicesSection(
                  service: service,
                  primary: primary,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                ),
              ),

              // ── Top Artisans ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _FeaturedArtisansSection(
                  artisans: featured,
                  service: service,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  primary: primary,
                  isDark: isDark,
                ),
              ),

              // ── Why Choose Us ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _WhyChooseUs(
                  primary: primary,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                ),
              ),

              // Bottom padding for sticky button
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 90,
                ),
              ),
            ],
          ),

          // ── Sticky Book Button ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BookButton(
              service: service,
              primary: primary,
              isDark: isDark,
              bottomInset: MediaQuery.of(context).padding.bottom,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Header
// ─────────────────────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final ServiceCategoryModel service;
  const _HeroHeader({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: service.gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative bg circles
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: 20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.custom24,
                AppSpacing.custom52,
                AppSpacing.custom24,
                AppSpacing.custom24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Big icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(service.icon, color: Colors.white, size: 38),
                  ),
                  AppGaps.h16,

                  // Service name
                  Text(
                    service.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                  AppGaps.h8,

                  // Quick badges row
                  Row(
                    children: [
                      _HeroBadge(
                        icon: Icons.verified_rounded,
                        label: 'Verified Pros',
                      ),
                      const SizedBox(width: 8),
                      _HeroBadge(
                        icon: Icons.timer_outlined,
                        label: 'Fast Response',
                      ),
                      const SizedBox(width: 8),
                      _HeroBadge(icon: Icons.shield_outlined, label: 'Insured'),
                    ],
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

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmallMedium(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Back Button
// ─────────────────────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.all(AppSpacing.custom8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.custom12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Strip  (3 columns)
// ─────────────────────────────────────────────────────────────────────────────

class _StatsStrip extends StatelessWidget {
  final ServiceCategoryModel service;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;

  const _StatsStrip({
    required this.service,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.custom16),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.custom16,
        horizontal: AppSpacing.custom8,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.people_rounded,
              value: '${service.artisanCount}+',
              label: 'Artisans',
              primary: primary,
              textColor: textColor,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.star_rounded,
              value: service.avgRating.toStringAsFixed(1),
              label: 'Avg. Rating',
              primary: primary,
              textColor: textColor,
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.payments_outlined,
              value: 'From',
              subValue: service.startingPrice,
              label: 'Starting price',
              primary: primary,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2));
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? subValue;
  final String label;
  final Color primary;
  final Color textColor;

  const _StatItem({
    required this.icon,
    required this.value,
    this.subValue,
    required this.label,
    required this.primary,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: primary, size: 22),
        AppGaps.h4,
        if (subValue != null) ...[
          Text(
            value,
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withOpacity(0.5),
            ),
          ),
          Text(
            subValue!,
            style: AppTextStyles.bodyMediumBold(color: textColor),
          ),
        ] else
          Text(value, style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h2,
        Text(
          label,
          style: AppTextStyles.bodySmallRegular(
            color: textColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Description Section
// ─────────────────────────────────────────────────────────────────────────────

class _DescriptionSection extends StatefulWidget {
  final ServiceCategoryModel service;
  final Color textColor;
  final Color primary;
  final bool isDark;

  const _DescriptionSection({
    required this.service,
    required this.textColor,
    required this.primary,
    required this.isDark,
  });

  @override
  State<_DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<_DescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        0,
        AppSpacing.custom16,
        AppSpacing.custom16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this service',
            style: AppTextStyles.bodyLargeBold(color: widget.textColor),
          ),
          AppGaps.h8,
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.service.description,
              style: AppTextStyles.bodyMediumRegular(
                color: widget.textColor.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.service.description,
              style: AppTextStyles.bodyMediumRegular(
                color: widget.textColor.withOpacity(0.7),
              ),
            ),
          ),
          AppGaps.h4,
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: AppTextStyles.bodySmallSemibold(color: widget.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Popular Services chips
// ─────────────────────────────────────────────────────────────────────────────

class _PopularServicesSection extends StatelessWidget {
  final ServiceCategoryModel service;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;

  const _PopularServicesSection({
    required this.service,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        0,
        AppSpacing.custom16,
        AppSpacing.custom24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppGaps.w8,
              Text(
                'Popular Services',
                style: AppTextStyles.bodyLargeBold(color: textColor),
              ),
            ],
          ),
          AppGaps.h10,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.popularServices.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  s,
                  style: AppTextStyles.bodySmallSemibold(color: primary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Featured Artisans  (horizontal scroll)
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturedArtisansSection extends StatelessWidget {
  final List<ArtisanModel> artisans;
  final ServiceCategoryModel service;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;
  final bool isDark;

  const _FeaturedArtisansSection({
    required this.artisans,
    required this.service,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppGaps.w8,
              Text(
                'Top Artisans',
                style: AppTextStyles.bodyLargeBold(color: textColor),
              ),
            ],
          ),
        ),
        AppGaps.h10,
        SizedBox(
          height: 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
            separatorBuilder: (_, __) => AppGaps.w16,
            itemCount: artisans.length,
            itemBuilder: (context, index) => _ArtisanCard(
              artisan: artisans[index],
              surfaceColor: surfaceColor,
              textColor: textColor,
              primary: primary,
            ),
          ),
        ),
        AppGaps.h24,
      ],
    );
  }
}

class _ArtisanCard extends StatelessWidget {
  final ArtisanModel artisan;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;

  const _ArtisanCard({
    required this.artisan,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      padding: EdgeInsets.all(AppSpacing.custom14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        border: Border.all(color: primary.withValues(alpha: 0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    artisan.initials,
                    style: AppTextStyles.bodySmallBold(color: primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (artisan.isVerified)
                          Icon(
                            Icons.verified_rounded,
                            color: primary,
                            size: 12,
                          ),
                        if (artisan.isVerified) const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            artisan.name.split(' ').first,
                            style: AppTextStyles.bodySmallSemibold(
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Online indicator
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: artisan.isOnline
                                ? const Color(0xFF22C55E)
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          artisan.isOnline ? 'Online' : 'Offline',
                          style: AppTextStyles.bodySmallRegular(
                            color: artisan.isOnline
                                ? const Color(0xFF22C55E)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          AppGaps.h10,

          Text(
            artisan.specialty,
            style: AppTextStyles.bodySmallMedium(
              color: textColor.withOpacity(0.65),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          AppGaps.h8,

          // Rating
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFf59e0b),
                size: 13,
              ),
              const SizedBox(width: 3),
              Text(
                artisan.rating.toStringAsFixed(1),
                style: AppTextStyles.bodySmallBold(color: textColor),
              ),
              const SizedBox(width: 4),
              Text(
                '(${artisan.reviews})',
                style: AppTextStyles.bodySmallRegular(
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Price & jobs
          Row(
            children: [
              Text(
                artisan.startingPrice,
                style: AppTextStyles.bodySmallBold(color: primary),
              ),
              const Spacer(),
              Text(
                '${artisan.completedJobs} jobs',
                style: AppTextStyles.bodySmallRegular(
                  color: textColor.withOpacity(0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Why Choose Us
// ─────────────────────────────────────────────────────────────────────────────

class _WhyChooseUs extends StatelessWidget {
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const _WhyChooseUs({
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  static const _items = [
    (
      Icons.verified_user_outlined,
      'Verified & Vetted',
      'All artisans go through identity and skills verification',
    ),
    (
      Icons.payment_outlined,
      'Secure Payments',
      'Money held safely until you confirm job completion',
    ),
    (
      Icons.support_agent_rounded,
      '24/7 Support',
      'We\'re here to help if anything doesn\'t go to plan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppGaps.w8,
              Text(
                'Why FixConnect?',
                style: AppTextStyles.bodyLargeBold(color: textColor),
              ),
            ],
          ),
          AppGaps.h10,
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.custom14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(AppSpacing.custom16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.$1, color: primary, size: 22),
                    ),
                    AppGaps.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$2,
                            style: AppTextStyles.bodyMediumSemibold(
                              color: textColor,
                            ),
                          ),
                          AppGaps.h2,
                          Text(
                            item.$3,
                            style: AppTextStyles.bodySmallRegular(
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sticky Book CTA Button
// ─────────────────────────────────────────────────────────────────────────────

class _BookButton extends StatelessWidget {
  final ServiceCategoryModel service;
  final Color primary;
  final bool isDark;
  final double bottomInset;

  const _BookButton({
    required this.service,
    required this.primary,
    required this.isDark,
    required this.bottomInset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom12,
        AppSpacing.custom16,
        bottomInset + AppSpacing.custom12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking a ${service.label} pro — coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppSpacing.custom16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.black87 : Colors.white,
                size: 20,
              ),
              AppGaps.w8,
              Text(
                'Find a ${service.label} Pro',
                style: AppTextStyles.bodyLargeSemibold(
                  color: isDark ? Colors.black87 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
