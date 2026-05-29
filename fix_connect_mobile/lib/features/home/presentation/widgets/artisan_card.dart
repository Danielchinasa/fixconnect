import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

class ArtisanCard extends StatelessWidget {
  final ArtisanModel artisan;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const ArtisanCard({
    super.key,
    required this.artisan,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.custom150,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.black.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.20 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar row + inline badges ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: artisan.badgeColor.withOpacity(0.15),
                      backgroundImage: artisan.avatarUrl != null
                          ? NetworkImage(artisan.avatarUrl!)
                          : null,
                      child: artisan.avatarUrl == null
                          ? Text(
                              artisan.initials,
                              style: AppTextStyles.bodyMediumBold(
                                color: artisan.badgeColor,
                              ),
                            )
                          : null,
                    ),
                    // Online / offline indicator
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: artisan.isOnline
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF9E9E9E),
                          shape: BoxShape.circle,
                          border: Border.all(color: surfaceColor, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Badges stacked at top-right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (artisan.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '★',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    if (artisan.isVerified) ...[
                      if (artisan.isFeatured) const SizedBox(height: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF22C55E),
                        size: 18,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Name ────────────────────────────────────────────────────────
            Text(
              artisan.name,
              style: AppTextStyles.bodyMediumSemibold(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            // ── Category / specialty pill ────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                artisan.categories.isNotEmpty
                    ? artisan.categories.first.name
                    : artisan.specialty,
                style: AppTextStyles.bodySmallMedium(color: primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),

            // ── Rating ──────────────────────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: artisan.rating > 0
                      ? const Color(0xFFFFB800)
                      : const Color(0xFF9E9E9E),
                  size: 13,
                ),
                const SizedBox(width: 3),
                Text(
                  artisan.rating > 0
                      ? artisan.rating.toStringAsFixed(1)
                      : 'New',
                  style: AppTextStyles.bodySmallBold(color: textColor),
                ),
                if (artisan.reviews > 0) ...[
                  const SizedBox(width: 2),
                  Text(
                    '(${artisan.reviews})',
                    style: AppTextStyles.bodySmallRegular(
                      color: textColor.withOpacity(0.45),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // ── Divider ─────────────────────────────────────────────────────
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
            ),
            const SizedBox(height: 8),

            // ── Starting price ───────────────────────────────────────────────
            Text(
              'From ${artisan.startingPrice}',
              style: AppTextStyles.bodySmallSemibold(color: primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
