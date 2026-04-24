import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

/// Expandable description block for a service category.
class ServiceDescriptionSection extends StatefulWidget {
  final ServiceCategoryModel service;
  const ServiceDescriptionSection({super.key, required this.service});

  @override
  State<ServiceDescriptionSection> createState() => _ServiceDescriptionSectionState();
}

class _ServiceDescriptionSectionState extends State<ServiceDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final primary = context.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0, AppSpacing.custom16, AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('About this service', style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h8,
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(widget.service.description,
              style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.7)),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          secondChild: Text(widget.service.description,
              style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.7))),
        ),
        AppGaps.h4,
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Show less' : 'Read more',
              style: AppTextStyles.bodySmallSemibold(color: primary)),
        ),
      ]),
    );
  }
}
