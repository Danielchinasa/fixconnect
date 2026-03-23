import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AvailableNowStrip extends StatelessWidget {
  final List<Map<String, dynamic>> artisans;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;

  const AvailableNowStrip({
    super.key,
    required this.artisans,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final online = artisans.where((a) => a['isOnline'] == true).toList();
    if (online.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 92,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: online.length,
        itemBuilder: (context, index) {
          final a = online[index];
          final Color badgeColor = a['badgeColor'] as Color;
          final String initials = a['initials'] as String;
          final String name = (a['name'] as String).split(' ').first;
          final String specialty = a['specialty'] as String;

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Glowing ring for online status
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF22C55E),
                            width: 2.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            backgroundColor: badgeColor.withOpacity(0.15),
                            child: Text(
                              initials,
                              style: AppTextStyles.bodyMediumBold(
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Online dot
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: AppTextStyles.bodySmallMedium(color: textColor),
                  ),
                  Text(
                    specialty.split(' ').first,
                    style: AppTextStyles.bodySmallRegular(
                      color: textColor.withOpacity(0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
