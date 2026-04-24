import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';

/// "Why FixConnect?" trust-building section.
class ServiceWhyChooseUs extends StatelessWidget {
  const ServiceWhyChooseUs({super.key});

  static const _items = [
    (Icons.verified_user_outlined, 'Verified & Vetted',
        'All artisans go through identity and skills verification'),
    (Icons.payment_outlined, 'Secure Payments',
        'Money held safely until you confirm job completion'),
    (Icons.support_agent_rounded, '24/7 Support',
        "We're here to help if anything doesn't go to plan"),
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 18,
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2))),
          AppGaps.w8,
          Text('Why FixConnect?', style: AppTextStyles.bodyLargeBold(color: textColor)),
        ]),
        AppGaps.h10,
        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.custom14),
            decoration: BoxDecoration(color: surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.custom16)),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(item.$1, color: primary, size: 22),
              ),
              AppGaps.w16,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.$2, style: AppTextStyles.bodyMediumSemibold(color: textColor)),
                AppGaps.h2,
                Text(item.$3, style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.6))),
              ])),
            ]),
          ),
        )),
      ]),
    );
  }
}
