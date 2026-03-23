import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LocationPickerSheet extends StatelessWidget {
  final String currentLocation;
  final List<String> locations;
  final void Function(String) onSelect;

  const LocationPickerSheet({
    super.key,
    required this.currentLocation,
    required this.locations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),
          Text(
            'Select your city',
            style: AppTextStyles.bodyLargeBold(color: textColor),
          ),
          const SizedBox(height: 16),
          ...locations.map(
            (loc) => ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                loc,
                style: AppTextStyles.bodyMediumMedium(color: textColor),
              ),
              trailing: loc == currentLocation
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () => onSelect(loc),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
