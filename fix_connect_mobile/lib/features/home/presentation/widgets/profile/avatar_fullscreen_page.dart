import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

class AvatarFullscreenPage extends StatelessWidget {
  final ArtisanModel artisan;
  final Color badgeColor;

  const AvatarFullscreenPage({
    super.key,
    required this.artisan,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.88),
          child: Stack(
            children: [
              // Close button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Centred hero avatar
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'artisan_avatar_${artisan.id}',
                      child: Builder(
                        builder: (context) {
                          final size = MediaQuery.of(context).size.width * 0.82;
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: badgeColor.withOpacity(0.55),
                                  blurRadius: 80,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                artisan.initials,
                                style: TextStyle(
                                  fontSize: size * 0.38,
                                  fontWeight: FontWeight.w800,
                                  color: badgeColor,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          artisan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (artisan.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      artisan.specialty,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Tap anywhere to close',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
