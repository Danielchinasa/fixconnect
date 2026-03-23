import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

class ArtisanListTile extends StatelessWidget {
  final ArtisanModel artisan;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;

  const ArtisanListTile({
    super.key,
    required this.artisan,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: artisan.isVerified
              ? Border.all(color: const Color(0xFF22C55E), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (artisan.isVerified)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF22C55E),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Verified Artisan',
                      style: AppTextStyles.bodyMediumSemibold(
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                // Avatar + online dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: artisan.badgeColor.withOpacity(0.15),
                      child: Text(
                        artisan.initials,
                        style: AppTextStyles.bodyMediumBold(
                          color: artisan.badgeColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: artisan.isOnline
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF9E9E9E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            artisan.name,
                            style: AppTextStyles.bodyMediumBold(
                              color: textColor,
                            ),
                          ),
                          if (artisan.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.verified, color: primary, size: 14),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        artisan.specialty,
                        style: AppTextStyles.bodySmallRegular(
                          color: textColor.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${artisan.rating} (${artisan.reviews})',
                            style: AppTextStyles.bodySmallMedium(
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'From',
                      style: AppTextStyles.bodySmallRegular(
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      artisan.startingPrice,
                      style: AppTextStyles.bodyMediumBold(color: primary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Book',
                        style: AppTextStyles.bodySmallBold(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
