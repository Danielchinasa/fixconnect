import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Card used in the artisan orders list.
/// Shows who the customer is, what they need, date/time, and the current status.
class ArtisanOrderCard extends StatelessWidget {
  final BookingModel booking;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final VoidCallback? onTap;

  const ArtisanOrderCard({
    super.key,
    required this.booking,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final status = booking.status;
    final statusColor = status.color;

    // Customer avatar uses a deterministic colour from the customer name hash
    final avatarColors = const [
      Color(0xFF6366F1),
      Color(0xFF22C55E),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
      Color(0xFF0EA5E9),
    ];
    final avatarColor =
        avatarColors[(booking.customerName ?? booking.id).hashCode.abs() %
            avatarColors.length];
    final initials = booking.customerInitials ?? '?';
    final customerDisplay = booking.customerName ?? 'Customer';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.custom16,
          vertical: AppSpacing.custom4,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: customer info + status badge ──────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.custom16,
                AppSpacing.custom16,
                AppSpacing.custom16,
                AppSpacing.custom12,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: avatarColor.withValues(alpha: 0.15),
                    child: Text(
                      initials,
                      style: AppTextStyles.bodySmallBold(color: avatarColor),
                    ),
                  ),
                  SizedBox(width: AppSpacing.custom8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerDisplay,
                          style: AppTextStyles.bodyMediumBold(color: textColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          booking.service,
                          style: AppTextStyles.bodySmallRegular(
                            color: textColor.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
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
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
              child: Divider(
                height: 1,
                color: textColor.withValues(alpha: 0.08),
              ),
            ),

            // ── Bottom row: date, time, price ──────────────────────────
            Padding(
              padding: EdgeInsets.all(AppSpacing.custom16),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _Chip(
                          icon: Icons.calendar_today_rounded,
                          label: DateFormat(
                            'EEE, d MMM',
                          ).format(booking.scheduledDate),
                          textColor: textColor,
                          primary: primary,
                        ),
                        _Chip(
                          icon: Icons.access_time_rounded,
                          label: booking.timeSlot,
                          textColor: textColor,
                          primary: primary,
                        ),
                      ],
                    ),
                  ),
                  // Price / CTA
                  _PriceTag(
                    booking: booking,
                    primary: primary,
                    textColor: textColor,
                    surfaceColor: surfaceColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor, primary;

  const _Chip({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: textColor.withValues(alpha: 0.45)),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmallMedium(
            color: textColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  final BookingModel booking;
  final Color primary, textColor, surfaceColor;

  const _PriceTag({
    required this.booking,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    if (booking.status == BookingStatus.pending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Send Quote',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: surfaceColor,
          ),
        ),
      );
    }
    return Text(
      booking.totalPrice,
      style: AppTextStyles.bodyMediumBold(color: primary),
    );
  }
}
