import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/widgets/network_svg_icon.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Hero gradient header for ServiceDetailPage.
class ServiceHeroHeader extends StatelessWidget {
  final ServiceCategoryModel service;
  const ServiceHeroHeader({super.key, required this.service});

  /// Predefined gradient pairs cycled by service ID hash.
  /// Gives each category a consistent colour without needing the API to send one.
  static const _gradients = [
    [Color(0xFF0ea5e9), Color(0xFF0dd0f0)],
    [Color(0xFFf97316), Color(0xFFfbbf24)],
    [Color(0xFF22c55e), Color(0xFF4ade80)],
    [Color(0xFF8b5cf6), Color(0xFFc4b5fd)],
    [Color(0xFFef4444), Color(0xFFfca5a5)],
    [Color(0xFFf59e0b), Color(0xFFfde68a)],
    [Color(0xFF06b6d4), Color(0xFF67e8f9)],
    [Color(0xFFec4899), Color(0xFFf9a8d4)],
  ];

  List<Color> get _gradientColors {
    final hash = service.id.codeUnits.fold(0, (a, b) => a + b);
    return List<Color>.from(_gradients[hash % _gradients.length]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradientColors;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
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
                    child: _ServiceIcon(
                      iconSvg: service.iconSvg,
                      serviceName: service.name,
                    ),
                  ),
                  AppGaps.h16,
                  Text(
                    service.name,
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
                  Row(
                    children: [
                      ServiceHeroBadge(
                        icon: Icons.verified_rounded,
                        label: 'Verified Pros',
                      ),
                      const SizedBox(width: 8),
                      ServiceHeroBadge(
                        icon: Icons.timer_outlined,
                        label: 'Fast Response',
                      ),
                      const SizedBox(width: 8),
                      ServiceHeroBadge(
                        icon: Icons.shield_outlined,
                        label: 'Insured',
                      ),
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

/// Renders an inline SVG string; falls back to a category-appropriate icon.
class _ServiceIcon extends StatelessWidget {
  final String? iconSvg;
  final String serviceName;
  const _ServiceIcon({this.iconSvg, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    if (iconSvg != null && iconSvg!.isNotEmpty) {
      return SizedBox(
        width: 72,
        height: 72,
        child: SvgPicture.string(
          iconSvg!,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }
    return Icon(
      NetworkSvgIcon.iconForCategory(serviceName),
      color: Colors.white,
      size: 38,
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
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
