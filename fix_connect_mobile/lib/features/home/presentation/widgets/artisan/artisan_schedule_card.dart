import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/profile/profile_common_widgets.dart';
import 'package:flutter/material.dart';

/// Schedule & Availability card on the artisan profile.
class ArtisanScheduleCard extends StatelessWidget {
  final ArtisanModel artisan;

  const ArtisanScheduleCard({super.key, required this.artisan});

  static const _dayKeys = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _openColor = Color(0xFF22C55E);
  static const _closedColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isOpen = artisan.isTodayOpen;
    final statusColor = isOpen ? _openColor : _closedColor;
    final todayKey = _dayKeys[DateTime.now().weekday - 1];

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
            children: [
              Icon(Icons.schedule_rounded, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                'Schedule & Availability',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                ProfilePulseDot(color: statusColor, isActive: isOpen),
                const SizedBox(width: 10),
                Text(
                  isOpen ? 'Open Now' : 'Closed Today',
                  style: AppTextStyles.bodyMediumSemibold(color: statusColor),
                ),
                const SizedBox(width: 10),
                Text(
                  '·',
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    artisan.todayOpenTime.isNotEmpty
                        ? artisan.todayOpenTime
                        : 'Schedule unavailable',
                    style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withOpacity(0.75),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 15, color: primary),
              const SizedBox(width: 6),
              Text(
                'This Week',
                style: AppTextStyles.bodySmallSemibold(color: primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < _dayKeys.length; i++)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _dayLabels[i][0],
                        style: AppTextStyles.bodySmallMedium(
                          color: _dayKeys[i] == todayKey
                              ? primary
                              : textColor.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: artisan.weeklySchedule[_dayKeys[i]] != null
                              ? _openColor.withOpacity(0.12)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: _dayKeys[i] == todayKey
                              ? Border.all(color: primary, width: 2)
                              : Border.all(
                                  color:
                                      (artisan.weeklySchedule[_dayKeys[i]] !=
                                                  null
                                              ? _openColor
                                              : _closedColor)
                                          .withOpacity(0.3),
                                  width: 1,
                                ),
                        ),
                        child: Center(
                          child: Icon(
                            artisan.weeklySchedule[_dayKeys[i]] != null
                                ? Icons.check_rounded
                                : Icons.close_rounded,
                            size: 13,
                            color: artisan.weeklySchedule[_dayKeys[i]] != null
                                ? _openColor
                                : _closedColor.withOpacity(0.45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: textColor.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.bolt_rounded, color: primary, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Response Time',
                    style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artisan.responseTime.isNotEmpty
                        ? artisan.responseTime
                        : 'Within 24 hours',
                    style: AppTextStyles.bodyMediumBold(color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
