import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

/// Expandable bio section on the artisan profile page.
class ArtisanAboutSection extends StatefulWidget {
  final ArtisanModel artisan;

  const ArtisanAboutSection({super.key, required this.artisan});

  @override
  State<ArtisanAboutSection> createState() => _ArtisanAboutSectionState();
}

class _ArtisanAboutSectionState extends State<ArtisanAboutSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    final bio = widget.artisan.bio.isNotEmpty
        ? widget.artisan.bio
        : 'Skilled professional ready to help with your needs.';
    final isLong = bio.length > 120;

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
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: textColor.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'About',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bio,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTextStyles.bodyMediumRegular(
              color: textColor.withOpacity(0.8),
            ),
          ),
          if (isLong) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? 'Show less' : 'Read more',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
