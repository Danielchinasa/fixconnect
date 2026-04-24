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

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _openColor = Color(0xFF22C55E);
  static const _closedColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isOpen = artisan.isTodayOpen;
    final statusColor = isOpen ? _openColor : _closedColor;
    final todayName = _dayNames[DateTime.now().weekday - 1];

    final openDayRows = <Widget>[
      for (final day in _dayNames)
        if (artisan.weeklySchedule[day] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    day,
                    style: AppTextStyles.bodySmallSemibold(
                      color: day == todayName ? primary : textColor.withOpacity(0.65),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 12, color: textColor.withOpacity(0.15)),
                const SizedBox(width: 8),
                Text(
                  artisan.weeklySchedule[day]!,
                  style: AppTextStyles.bodySmallRegular(color: textColor.withOpacity(0.75)),
                ),
                if (day == todayName) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Today',
                      style: AppTextStyles.bodySmallBold(color: primary).copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.schedule_rounded, size: 18, color: textColor.withOpacity(0.7)),
            const SizedBox(width: 8),
            Text('Schedule & Availability', style: AppTextStyles.bodyMediumBold(color: textColor)),
          ]),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
            ),
            child: Row(children: [
              ProfilePulseDot(color: statusColor, isActive: isOpen),
              const SizedBox(width: 10),
              Text(isOpen ? 'Open Now' : 'Closed Today',
                  style: AppTextStyles.bodyMediumSemibold(color: statusColor)),
              const SizedBox(width: 10),
              Text('·', style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  artisan.todayOpenTime.isNotEmpty ? artisan.todayOpenTime : 'Schedule unavailable',
                  style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.75)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Icon(Icons.calendar_month_rounded, size: 15, color: textColor.withOpacity(0.5)),
            const SizedBox(width: 6),
            Text('This Week', style: AppTextStyles.bodySmallSemibold(color: textColor.withOpacity(0.6))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            for (final day in _dayNames)
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(day[0], style: AppTextStyles.bodySmallMedium(
                      color: day == todayName ? primary : textColor.withOpacity(0.55))),
                  const SizedBox(height: 6),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: artisan.weeklySchedule[day] != null ? _openColor.withOpacity(0.12) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: day == todayName
                          ? Border.all(color: primary, width: 2)
                          : Border.all(
                              color: (artisan.weeklySchedule[day] != null ? _openColor : _closedColor).withOpacity(0.3),
                              width: 1),
                    ),
                    child: Center(child: Icon(
                      artisan.weeklySchedule[day] != null ? Icons.check_rounded : Icons.close_rounded,
                      size: 13,
                      color: artisan.weeklySchedule[day] != null ? _openColor : _closedColor.withOpacity(0.45),
                    )),
                  ),
                ]),
              ),
          ]),
          const SizedBox(height: 16),
          if (openDayRows.isNotEmpty) ...openDayRows,
          const SizedBox(height: 8),
          Divider(color: textColor.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt_rounded, color: Color(0xFFFFB800), size: 18),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Response Time', style: AppTextStyles.bodyMediumRegular(color: textColor.withOpacity(0.5))),
              const SizedBox(height: 2),
              Text(
                artisan.responseTime.isNotEmpty ? artisan.responseTime : 'Within 24 hours',
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
            ]),
          ]),
        ],
      ),
    );
  }
}
