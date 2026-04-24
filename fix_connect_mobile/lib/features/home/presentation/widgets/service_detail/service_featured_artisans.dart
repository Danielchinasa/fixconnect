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
