import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_work_sample_card.dart';
import 'package:flutter/material.dart';

/// Grid of work sample images for the artisan profile.
class ArtisanWorkSamplesSection extends StatelessWidget {
  final List<WorkSample> samples;

  const ArtisanWorkSamplesSection({super.key, required this.samples});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_library_rounded,
                    size: 18,
                    color: textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Work Samples',
                    style: AppTextStyles.bodyMediumBold(color: textColor),
                  ),
                ],
              ),
              Text(
                'See all',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: samples.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (_, i) => ProfileWorkSampleCard(sample: samples[i]),
          ),
        ],
      ),
    );
  }
}
