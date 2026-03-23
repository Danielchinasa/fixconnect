import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/home/data/models/home_filter.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final HomeFilter filter;
  final Color primary;
  final void Function(HomeFilter) onApply;
  final VoidCallback onReset;

  const FilterSheet({
    super.key,
    required this.filter,
    required this.primary,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String? _category;
  late double _minRating;
  late bool _verifiedOnly;
  late int? _maxDistance;

  static const _distanceOptions = [
    (label: 'Any', value: null as int?),
    (label: '2 km', value: 2 as int?),
    (label: '5 km', value: 5 as int?),
    (label: '10 km', value: 10 as int?),
    (label: '20 km', value: 20 as int?),
    (label: '50 km', value: 50 as int?),
  ];

  static const _categories = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Painting',
    'HVAC',
    'Landscaping',
    'Moving',
    'Mechanic',
  ];

  static const _ratingOptions = [
    (label: 'Any', value: 0.0),
    (label: '3+', value: 3.0),
    (label: '4+', value: 4.0),
    (label: '4.5+', value: 4.5),
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.filter.category;
    _minRating = widget.filter.minRating;
    _verifiedOnly = widget.filter.verifiedOnly;
    _maxDistance = widget.filter.maxDistance;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final primary = widget.primary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Artisans',
                style: AppTextStyles.bodyLargeBold(color: textColor),
              ),
              GestureDetector(
                onTap: widget.onReset,
                child: Text(
                  'Reset',
                  style: AppTextStyles.bodyMediumSemibold(color: primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category
          Text(
            'Category',
            style: AppTextStyles.bodyMediumBold(color: textColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _category == cat;
              return GestureDetector(
                onTap: () =>
                    setState(() => _category = isSelected ? null : cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primary : AppColors.grey300,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: AppTextStyles.bodySmallMedium(
                      color: isSelected
                          ? Theme.of(context).colorScheme.surface
                          : textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Min Rating
          Text(
            'Minimum Rating',
            style: AppTextStyles.bodyMediumBold(color: textColor),
          ),
          const SizedBox(height: 10),
          Row(
            children: _ratingOptions.map((opt) {
              final isSelected = _minRating == opt.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _minRating = opt.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? primary : AppColors.grey300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (opt.value > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          opt.label,
                          style: AppTextStyles.bodySmallMedium(
                            color: isSelected
                                ? Theme.of(context).colorScheme.surface
                                : textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Distance
          Text(
            'Distance from you',
            style: AppTextStyles.bodyMediumBold(color: textColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _distanceOptions.map((opt) {
              final isSelected = _maxDistance == opt.value;
              return GestureDetector(
                onTap: () => setState(() => _maxDistance = opt.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primary : AppColors.grey300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.near_me_rounded,
                        size: 13,
                        color: isSelected
                            ? Colors.white
                            : textColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        opt.label,
                        style: AppTextStyles.bodySmallMedium(
                          color: isSelected
                              ? Theme.of(context).colorScheme.surface
                              : textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Verified only
          GestureDetector(
            onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _verifiedOnly ? primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _verifiedOnly ? primary : AppColors.grey400,
                    ),
                  ),
                  child: _verifiedOnly
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  'Verified artisans only',
                  style: AppTextStyles.bodyMediumMedium(color: textColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => widget.onApply(
                HomeFilter(
                  category: _category,
                  minRating: _minRating,
                  verifiedOnly: _verifiedOnly,
                  maxDistance: _maxDistance,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: AppTextStyles.header4Bold(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
