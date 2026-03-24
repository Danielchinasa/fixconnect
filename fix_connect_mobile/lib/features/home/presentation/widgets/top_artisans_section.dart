import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan_card.dart';
import 'package:flutter/material.dart';

class TopArtisansSection extends StatelessWidget {
  final List<ArtisanModel> artisans;
  final Color surfaceColor;
  final Color textColor;
  final Color primary;
  final bool isDark;
  final void Function(ArtisanModel)? onArtisanTap;

  const TopArtisansSection({
    super.key,
    required this.artisans,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
    required this.isDark,
    this.onArtisanTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.custom200,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: artisans.length,
        itemBuilder: (context, index) {
          final artisan = artisans[index];
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.custom16),
            child: ArtisanCard(
              artisan: artisan,
              surfaceColor: surfaceColor,
              textColor: textColor,
              primary: primary,
              isDark: isDark,
              onTap: () => onArtisanTap?.call(artisan),
            ),
          );
        },
      ),
    );
  }
}
