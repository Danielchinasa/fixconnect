import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatsStrip extends StatelessWidget {
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const StatsStrip({
    super.key,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  static const _stats = [
    (value: '5,200+', label: 'Jobs Done'),
    (value: '300+', label: 'Artisans'),
    (value: '4.8★', label: 'Avg Rating'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(_stats.length * 2 - 1, (i) {
          // Insert dividers between items
          if (i.isOdd) {
            return Container(
              width: 1,
              height: 32,
              color: Colors.grey.withOpacity(0.2),
            );
          }
          final stat = _stats[i ~/ 2];
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.value,
                  style: AppTextStyles.bodyLargeBold(color: primary),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.55),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
