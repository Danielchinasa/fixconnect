import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class EmptySearchResult extends StatelessWidget {
  final String query;
  final Color textColor;
  final Color primary;

  const EmptySearchResult({
    super.key,
    required this.query,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty
                ? 'No results match your filters'
                : 'No results for "$query"',
            style: AppTextStyles.bodyLargeBold(color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different keyword or adjust your filters',
            style: AppTextStyles.bodyMediumRegular(
              color: textColor.withOpacity(0.55),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
