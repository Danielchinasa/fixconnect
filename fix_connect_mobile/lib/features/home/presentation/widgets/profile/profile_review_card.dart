import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/review_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:flutter/material.dart';

class ProfileReviewCard extends StatelessWidget {
  final ReviewModel review;
  final Color textColor;
  final bool isDark;

  const ProfileReviewCard({
    super.key,
    required this.review,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: review.avatarColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              review.reviewerInitials,
              style: AppTextStyles.bodySmallBold(color: review.avatarColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.reviewerName,
                      style: AppTextStyles.bodyMediumSemibold(color: textColor),
                    ),
                  ),
                  Text(
                    review.timeAgo,
                    style: AppTextStyles.bodySmallRegular(
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              ProfileStarRow(rating: review.rating),
              const SizedBox(height: 6),
              Text(
                review.comment,
                style: AppTextStyles.bodySmallRegular(
                  color: textColor.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
