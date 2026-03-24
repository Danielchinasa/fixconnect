import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

class ProfileHeroHeader extends StatelessWidget {
  final ArtisanModel artisan;
  final VoidCallback onAvatarTap;

  const ProfileHeroHeader({
    super.key,
    required this.artisan,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = artisan.badgeColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            badgeColor,
            badgeColor.withOpacity(0.75),
            badgeColor.withOpacity(0.45),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative background circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // Avatar — tap to enlarge
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Hero(
                      tag: 'artisan_avatar_${artisan.id}',
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 148,
                            height: 148,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          // Avatar circle
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              width: 136,
                              height: 136,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  artisan.initials,
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                    color: badgeColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Online status dot
                          Positioned(
                            bottom: 6,
                            right: 4,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: artisan.isOnline
                                    ? const Color(0xFF22C55E)
                                    : AppColors.grey500,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Name + Verified icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        artisan.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (artisan.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Specialty
                  Text(
                    artisan.specialty,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.88),
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Online status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: artisan.isOnline
                                ? const Color(0xFF4ADE80)
                                : Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          artisan.isOnline ? 'Online Now' : 'Currently Offline',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
