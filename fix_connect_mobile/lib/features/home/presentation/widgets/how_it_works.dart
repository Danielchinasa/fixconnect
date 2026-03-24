import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HowItWorks extends StatelessWidget {
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const HowItWorks({
    super.key,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  static const _steps = [
    (
      icon: Icons.search_rounded,
      title: 'Search',
      desc: 'Find verified artisans near you',
    ),
    (
      icon: Icons.calendar_today_rounded,
      title: 'Book',
      desc: 'Schedule at your convenience',
    ),
    (
      icon: Icons.verified_outlined,
      title: 'Done & Paid',
      desc: 'Release payment when satisfied',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: EdgeInsets.all(AppSpacing.custom16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How FixConnect works',
            style: AppTextStyles.bodyLargeBold(color: textColor),
          ),
          SizedBox(height: AppSpacing.custom16),
          Row(
            children: _steps.map((s) {
              final isLast = s == _steps.last;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(s.icon, color: primary, size: 22),
                          ),
                          SizedBox(height: AppSpacing.custom4),
                          Text(
                            s.title,
                            style: AppTextStyles.bodySmallBold(
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.desc,
                            style: AppTextStyles.bodySmallRegular(
                              color: textColor.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: textColor.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
