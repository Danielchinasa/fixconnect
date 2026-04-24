"""
Script to write all extracted widget files for the FixConnect refactor.
Run: python3 scripts/write_widgets.py
"""
import os

BASE = '/Applications/MAMP/htdocs/fixconnect/fix_connect_mobile/lib'

def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    print(f'✓ {path.replace(BASE, "lib")}')


# ── Artisan Schedule Card ──────────────────────────────────────────────────────
write(f'{BASE}/features/home/presentation/widgets/artisan/artisan_schedule_card.dart', """
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:flutter/material.dart';

/// Schedule & Availability card on the artisan profile.
class ArtisanScheduleCard extends StatelessWidget {
  final ArtisanModel artisan;

  const ArtisanScheduleCard({super.key, required this.artisan});

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _openColor = Color(0xFF22C55E);
  static const _closedColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isOpen = artisan.isTodayOpen;
    final statusColor = isOpen ? _openColor : _closedColor;
    final todayName = _dayNames[DateTime.now().weekday - 1];

    final openDayRows = <Widget>[
      for (final day in _dayNames)
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
                      color: day == todayName ? primary : textColor.withOpacity(0.65),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 12, color: textColor.withOpacity(0.15)),
                const SizedBox(width: 8),
                Text(
                  artisan.weeklySchedule[day]!,
                  style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.75)),
                ),
                if (day == todayName) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Today',
                      style: AppTextStyles.bodySmallBold(color: primary).copyWith(fontSize: 10),
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
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.schedule_rounded, size: 18, color: textColor.withOpacity(0.7)),
            const SizedBox(width: 8),
            Text('Schedule & Availability', style: AppTextStyles.bodyMediumBold(color: textColor)),
          ]),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Row(children: [
              ProfilePulseDot(color: statusColor, isActive: isOpen),
              const SizedBox(width: 10),
              Text(isOpen ? 'Open Now' : 'Closed Today',
                  style: AppTextStyles.bodyMediumSemibold(color: statusColor)),
              const SizedBox(width: 10),
              Text('·', style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  artisan.todayOpenTime.isNotEmpty ? artisan.todayOpenTime : 'Schedule unavailable',
                  style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.75)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Icon(Icons.calendar_month_rounded, size: 15, color: textColor.withOpacity(0.5)),
            const SizedBox(width: 6),
            Text('This Week', style: AppTextStyles.bodySmallSemibold(color: textColor.withOpacity(0.6))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            for (final day in _dayNames)
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(day[0], style: AppTextStyles.bodySmallMedium(
                      color: day == todayName ? primary : textColor.withOpacity(0.55))),
                  const SizedBox(height: 6),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: artisan.weeklySchedule[day] != null ? _openColor.withOpacity(0.12) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: day == todayName
                          ? Border.all(color: primary, width: 2)
                          : Border.all(
                              color: (artisan.weeklySchedule[day] != null ? _openColor : _closedColor).withOpacity(0.3),
                              width: 1),
                    ),
                    child: Center(child: Icon(
                      artisan.weeklySchedule[day] != null ? Icons.check_rounded : Icons.close_rounded,
                      size: 13,
                      color: artisan.weeklySchedule[day] != null ? _openColor : _closedColor.withOpacity(0.45),
                    )),
                  ),
                ]),
              ),
          ]),
          const SizedBox(height: 16),
          if (openDayRows.isNotEmpty) ...openDayRows,
          const SizedBox(height: 8),
          Divider(color: textColor.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt_rounded, color: Color(0xFFFFB800), size: 18),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Response Time', style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.5))),
              const SizedBox(height: 2),
              Text(
                artisan.responseTime.isNotEmpty ? artisan.responseTime : 'Within 24 hours',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ]),
          ]),
        ],
      ),
    );
  }
}
""".lstrip())


# ── Service Detail Widgets ─────────────────────────────────────────────────────
SDBASE = f'{BASE}/features/home/presentation/widgets/service_detail'

write(f'{SDBASE}/service_hero_header.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Hero gradient header for ServiceDetailPage.
class ServiceHeroHeader extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceHeroHeader({super.key, required this.service});

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
          Positioned(right: -40, top: -40,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(left: -30, bottom: 20,
            child: Container(width: 130, height: 130,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
          Positioned(right: 30, bottom: -20,
            child: Container(width: 80, height: 80,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle))),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.custom24, AppSpacing.custom52, AppSpacing.custom24, AppSpacing.custom24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Icon(service.icon, color: Colors.white, size: 38),
                  ),
                  AppGaps.h16,
                  Text(service.label, style: const TextStyle(
                    color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800,
                    height: 1.1, letterSpacing: -0.5, fontFamily: 'Inter')),
                  AppGaps.h8,
                  Row(children: [
                    ServiceHeroBadge(icon: Icons.verified_rounded, label: 'Verified Pros'),
                    const SizedBox(width: 8),
                    ServiceHeroBadge(icon: Icons.timer_outlined, label: 'Fast Response'),
                    const SizedBox(width: 8),
                    ServiceHeroBadge(icon: Icons.shield_outlined, label: 'Insured'),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small pill badge used in [ServiceHeroHeader].
class ServiceHeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const ServiceHeroBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 11),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmallMedium(color: Colors.white)),
      ]),
    );
  }
}

/// Transparent back button shown in the hero app bar.
class ServiceBackButton extends StatelessWidget {
  const ServiceBackButton({super.key});

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
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}
""".lstrip())

write(f'{SDBASE}/service_stats_strip.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Three-column stat strip (artisans, rating, price) below the hero.
class ServiceStatsStrip extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceStatsStrip({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return Container(
      margin: EdgeInsets.all(AppSpacing.custom16),
      padding: EdgeInsets.symmetric(vertical: AppSpacing.custom16, horizontal: AppSpacing.custom8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        Expanded(child: _StatItem(icon: Icons.people_rounded, value: '\${service.artisanCount}+',
            label: 'Artisans', primary: primary, textColor: textColor)),
        _StatDivider(),
        Expanded(child: _StatItem(icon: Icons.star_rounded, value: service.avgRating.toStringAsFixed(1),
            label: 'Avg. Rating', primary: primary, textColor: textColor)),
        _StatDivider(),
        Expanded(child: _StatItem(icon: Icons.payments_outlined, value: 'From',
            subValue: service.startingPrice, label: 'Starting price', primary: primary, textColor: textColor)),
      ]),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2));
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? subValue;
  final String label;
  final Color primary;
  final Color textColor;

  const _StatItem({
    required this.icon, required this.value, this.subValue,
    required this.label, required this.primary, required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: primary, size: 22),
      AppGaps.h4,
      if (subValue != null) ...[
        Text(value, style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.5))),
        Text(subValue!, style: AppTextStyles.bodyMediumBold(color: textColor)),
      ] else
        Text(value, style: AppTextStyles.bodyLargeBold(color: textColor)),
      AppGaps.h2,
      Text(label, style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.5))),
    ]);
  }
}
""".lstrip())

write(f'{SDBASE}/service_description_section.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Expandable description block for a service category.
class ServiceDescriptionSection extends StatefulWidget {
  final ServiceCategoryModel service;
  const ServiceDescriptionSection({super.key, required this.service});

  @override
  State<ServiceDescriptionSection> createState() => _ServiceDescriptionSectionState();
}

class _ServiceDescriptionSectionState extends State<ServiceDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0, AppSpacing.custom16, AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('About this service', style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h8,
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(widget.service.description,
              style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.7)),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          secondChild: Text(widget.service.description,
              style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.7))),
        ),
        AppGaps.h4,
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Show less' : 'Read more',
              style: AppTextStyles.bodySmallSemibold(color: primary)),
        ),
      ]),
    );
  }
}
""".lstrip())

write(f'{SDBASE}/service_popular_services.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Chip list of popular sub-services for a category.
class ServicePopularServices extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServicePopularServices({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0, AppSpacing.custom16, AppSpacing.custom24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          AppGaps.w8,
          Text('Popular Services', style: AppTextStyles.bodyLargeBold(color: textColor)),
        ]),
        AppGaps.h10,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: service.popularServices.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primary.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(s, style: AppTextStyles.bodySmallSemibold(color: primary)),
          )).toList(),
        ),
      ]),
    );
  }
}
""".lstrip())

write(f'{SDBASE}/service_featured_artisans.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

/// Horizontal scroll of featured artisan mini-cards.
class ServiceFeaturedArtisans extends StatelessWidget {
  final List<ArtisanModel> artisans;
  const ServiceFeaturedArtisans({super.key, required this.artisans});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
        child: Row(children: [
          Container(width: 4, height: 18,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          AppGaps.w8,
          Text('Top Artisans', style: AppTextStyles.bodyLargeBold(color: textColor)),
        ]),
      ),
      AppGaps.h10,
      SizedBox(
        height: 195,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
          separatorBuilder: (_, __) => AppGaps.w16,
          itemCount: artisans.length,
          itemBuilder: (_, i) => _ArtisanMiniCard(artisan: artisans[i],
              surfaceColor: surfaceColor, textColor: textColor, primary: primary),
        ),
      ),
      AppGaps.h24,
    ]);
  }
}

class _ArtisanMiniCard extends StatelessWidget {
  final ArtisanModel artisan;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;

  const _ArtisanMiniCard({
    required this.artisan, required this.surfaceColor,
    required this.textColor, required this.primary,
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Center(child: Text(artisan.initials, style: AppTextStyles.bodySmallBold(color: primary))),
          ),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (artisan.isVerified) ...[
                Icon(Icons.verified_rounded, color: primary, size: 12),
                const SizedBox(width: 3),
              ],
              Expanded(child: Text(artisan.name.split(' ').first,
                  style: AppTextStyles.bodySmallSemibold(color: textColor),
                  overflow: TextOverflow.ellipsis)),
            ]),
            Row(children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(
                  color: artisan.isOnline ? const Color(0xFF22C55E) : Colors.grey, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(artisan.isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.bodySmallRegular(
                      color: artisan.isOnline ? const Color(0xFF22C55E) : Colors.grey)),
            ]),
          ])),
        ]),
        AppGaps.h10,
        Text(artisan.specialty, style: AppTextStyles.bodySmallMedium(color: textColor.withOpacity(0.65)),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        AppGaps.h8,
        Row(children: [
          const Icon(Icons.star_rounded, color: Color(0xFFf59e0b), size: 13),
          const SizedBox(width: 3),
          Text(artisan.rating.toStringAsFixed(1), style: AppTextStyles.bodySmallBold(color: textColor)),
          const SizedBox(width: 4),
          Text('(\${artisan.reviews})', style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.5))),
        ]),
        const Spacer(),
        Row(children: [
          Text(artisan.startingPrice, style: AppTextStyles.bodySmallBold(color: primary)),
          const Spacer(),
          Text('\${artisan.completedJobs} jobs',
              style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.45))),
        ]),
      ]),
    );
  }
}
""".lstrip())

write(f'{SDBASE}/service_why_choose_us.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';

/// "Why FixConnect?" trust-building section.
class ServiceWhyChooseUs extends StatelessWidget {
  const ServiceWhyChooseUs({super.key});

  static const _items = [
    (Icons.verified_user_outlined, 'Verified & Vetted',
        'All artisans go through identity and skills verification'),
    (Icons.payment_outlined, 'Secure Payments',
        'Money held safely until you confirm job completion'),
    (Icons.support_agent_rounded, '24/7 Support',
        "We're here to help if anything doesn't go to plan"),
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          AppGaps.w8,
          Text('Why FixConnect?', style: AppTextStyles.bodyLargeBold(color: textColor)),
        ]),
        AppGaps.h10,
        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.custom14),
            decoration: BoxDecoration(color: surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.custom16)),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(item.$1, color: primary, size: 22),
              ),
              AppGaps.w16,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.$2, style: AppTextStyles.bodyMediumSemibold(color: textColor)),
                AppGaps.h2,
                Text(item.$3, style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.6))),
              ])),
            ]),
          ),
        )),
      ]),
    );
  }
}
""".lstrip())

write(f'{SDBASE}/service_book_button.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Sticky "Find a Pro" CTA button at the bottom of ServiceDetailPage.
class ServiceBookButton extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceBookButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final isDark = context.isDark;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.custom16, AppSpacing.custom12,
          AppSpacing.custom16, bottomInset + AppSpacing.custom12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1)),
      ),
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Booking a \${service.label} pro — coming soon!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        )),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(AppSpacing.custom16),
            boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 5))],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.search_rounded, color: isDark ? Colors.black87 : Colors.white, size: 20),
            AppGaps.w8,
            Text('Find a \${service.label} Pro',
                style: AppTextStyles.bodyLargeSemibold(color: isDark ? Colors.black87 : Colors.white)),
          ]),
        ),
      ),
    );
  }
}
""".lstrip())

# ── Payment Card Model ────────────────────────────────────────────────────────
os.makedirs(f'{BASE}/features/profile/data/models', exist_ok=True)
write(f'{BASE}/features/profile/data/models/payment_card.dart', """
enum CardBrand { visa, mastercard }

class PaymentCard {
  final String id;
  final CardBrand brand;
  final String last4;
  final String expiry;
  final String holderName;
  bool isDefault;

  String get brandName => brand == CardBrand.visa ? 'Visa' : 'Mastercard';

  PaymentCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.holderName,
    required this.isDefault,
  });
}
""".lstrip())

# ── Saved Address Model ───────────────────────────────────────────────────────
write(f'{BASE}/features/profile/data/models/saved_address.dart', """
import 'package:flutter/material.dart';

class SavedAddress {
  final String id;
  final String label;
  final IconData icon;
  final String street;
  final String city;
  final String state;
  bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.icon,
    required this.street,
    required this.city,
    required this.state,
    required this.isDefault,
  });
}
""".lstrip())

print("\\nAll files written successfully!")
