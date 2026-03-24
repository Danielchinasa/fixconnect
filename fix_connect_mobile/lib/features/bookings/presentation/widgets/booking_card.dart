import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 📚 CONCEPT: Reusable Presentation Widgets.
// This widget knows about BookingModel (data layer) but has no business logic.
// It just renders data and calls callbacks when the user interacts.
// This keeps it dumb (aka "dumb component" pattern) and highly reusable.
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status;
    final statusColor = status.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.custom16,
          vertical: AppSpacing.custom4,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom18),
          // 📚 CONCEPT: BoxShadow — a subtle shadow that lifts cards off the page.
          // Multiple shadows can be layered: one for depth, one for a soft glow.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.custom16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: artisan info + status badge
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: booking.artisanBadgeColor.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      booking.artisanInitials,
                      style: AppTextStyles.bodySmallBold(
                        color: booking.artisanBadgeColor,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.custom8),
                  // Name + specialty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.artisanName,
                          style: AppTextStyles.bodyMediumBold(color: textColor),
                        ),
                        Text(
                          booking.artisanSpecialty,
                          style: AppTextStyles.bodySmallRegular(
                            color: textColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  _StatusBadge(status: status, statusColor: statusColor),
                ],
              ),

              SizedBox(height: AppSpacing.custom16),

              // Divider
              Divider(height: 1, color: textColor.withValues(alpha: 0.08)),

              SizedBox(height: AppSpacing.custom16),

              // Booking details: service, date, time, price
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow(
                          icon: Icons.build_circle_outlined,
                          label: booking.service,
                          textColor: textColor,
                          iconColor: statusColor,
                        ),
                        SizedBox(height: AppSpacing.custom4),
                        _DetailRow(
                          icon: Icons.calendar_today_rounded,
                          label: DateFormat(
                            'EEE, d MMM yyyy',
                          ).format(booking.scheduledDate),
                          textColor: textColor,
                          iconColor: textColor.withValues(alpha: 0.45),
                        ),
                        SizedBox(height: AppSpacing.custom4),
                        _DetailRow(
                          icon: Icons.access_time_rounded,
                          label: booking.timeSlot,
                          textColor: textColor,
                          iconColor: textColor.withValues(alpha: 0.45),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        booking.totalPrice,
                        style: AppTextStyles.bodyLargeBold(color: statusColor),
                      ),
                      Text(
                        'Total',
                        style: AppTextStyles.bodySmallRegular(
                          color: textColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  final Color statusColor;

  const _StatusBadge({required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 11, color: statusColor),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: AppTextStyles.bodySmallSemibold(color: statusColor),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color iconColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: iconColor),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmallRegular(color: textColor)),
      ],
    );
  }
}
