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
    final cardInner = Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + online status dot
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

          const SizedBox(height: 8),

          // Name
          Text(
            artisan.name,
            style: AppTextStyles.bodySmallBold(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Specialty
          Text(
            artisan.specialty,
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withOpacity(0.55),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Rating
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB800),
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                '${artisan.rating}',
                style: AppTextStyles.bodySmallBold(color: textColor),
              ),
              const SizedBox(width: 3),
              Text(
                '(${artisan.reviews})',
                style: AppTextStyles.bodySmallRegular(
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Rate
          Text(
            'From ${artisan.startingPrice}',
            style: AppTextStyles.bodySmallSemibold(color: primary),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: artisan.isVerified
            ? Banner(
                message: 'Verified',
                location: BannerLocation.topEnd,
                color: const Color(0xFF22C55E),
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
                child: cardInner,
              )
            : cardInner,
      ),
    );
  }
}
