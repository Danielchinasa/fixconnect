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
