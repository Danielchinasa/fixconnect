import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_review_card.dart';
import 'package:flutter/material.dart';

/// Reviews summary + individual review cards for the artisan profile.
class ArtisanReviewsSection extends StatelessWidget {
  final ArtisanModel artisan;
  final List<dynamic> reviews;

  const ArtisanReviewsSection({
    super.key,
    required this.artisan,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isDark = context.isDark;

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

          // Rating summary
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
}
