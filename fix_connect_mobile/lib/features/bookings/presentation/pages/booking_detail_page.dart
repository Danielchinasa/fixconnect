import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final statusColor = booking.status.color;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Gradient header ──────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              backgroundColor: statusColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: EdgeInsets.all(AppSpacing.custom8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withValues(alpha: 0.85),
                        statusColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.custom24,
                        AppSpacing.custom52,
                        AppSpacing.custom24,
                        AppSpacing.custom20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  booking.status.icon,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking.status.label,
                                  style: AppTextStyles.bodySmallSemibold(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppGaps.h8,
                          Text(
                            booking.service,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          AppGaps.h4,
                          Text(
                            DateFormat(
                                  'EEEE, d MMMM yyyy',
                                ).format(booking.scheduledDate) +
                                ' · ' +
                                booking.timeSlot,
                            style: AppTextStyles.bodySmallMedium(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: AppGaps.h16),

            // ── Status timeline ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: _StatusTimeline(
                booking: booking,
                textColor: textColor,
                surfaceColor: surfaceColor,
              ),
            ),
            SliverToBoxAdapter(child: AppGaps.h16),

            // ── Artisan info ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Artisan',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
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
                    SizedBox(width: AppSpacing.custom12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.artisanName,
                            style: AppTextStyles.bodyMediumBold(
                              color: textColor,
                            ),
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
                    Row(
                      children: [
                        _CircleBtn(
                          icon: Icons.call_rounded,
                          color: AppColors.secondary,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _CircleBtn(
                          icon: Icons.chat_bubble_rounded,
                          color: primary,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── Service details ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Service Details',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Column(
                  children: [
                    _DetailRow(
                      Icons.build_circle_outlined,
                      'Service',
                      booking.service,
                      textColor,
                      primary,
                    ),
                    _DetailRow(
                      Icons.calendar_today_rounded,
                      'Date',
                      DateFormat(
                        'EEE, d MMM yyyy',
                      ).format(booking.scheduledDate),
                      textColor,
                      primary,
                    ),
                    _DetailRow(
                      Icons.access_time_rounded,
                      'Time',
                      booking.timeSlot,
                      textColor,
                      primary,
                    ),
                    _DetailRow(
                      Icons.payments_rounded,
                      'Total',
                      booking.totalPrice,
                      textColor,
                      primary,
                    ),
                    if (booking.notes != null)
                      _DetailRow(
                        Icons.notes_rounded,
                        'Notes',
                        booking.notes!,
                        textColor,
                        primary,
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── Address ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Address',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: AppSpacing.custom12),
                    Expanded(
                      child: Text(
                        booking.address,
                        style: AppTextStyles.bodyMediumMedium(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: AppGaps.h24),

            // ── Action buttons ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: _ActionButtons(
                booking: booking,
                primary: primary,
                textColor: textColor,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status timeline ────────────────────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final BookingModel booking;
  final Color textColor, surfaceColor;

  const _StatusTimeline({
    required this.booking,
    required this.textColor,
    required this.surfaceColor,
  });

  static const _steps = [
    (Icons.check_rounded, 'Confirmed'),
    (Icons.person_rounded, 'Assigned'),
    (Icons.construction_rounded, 'In Progress'),
    (Icons.check_circle_rounded, 'Completed'),
  ];

  int get _activeStep {
    switch (booking.status) {
      case BookingStatus.upcoming:
        return 1;
      case BookingStatus.inProgress:
        return 2;
      case BookingStatus.completed:
        return 3;
      case BookingStatus.cancelled:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final active = _activeStep;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.custom16,
        horizontal: AppSpacing.custom8,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = i ~/ 2 < active;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? primary : textColor.withValues(alpha: 0.1),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx <= active;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done ? primary : textColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _steps[idx].$1,
                  size: 15,
                  color: done ? Colors.white : textColor.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _steps[idx].$2,
                style: AppTextStyles.bodySmallRegular(
                  color: done ? primary : textColor.withValues(alpha: 0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Action buttons ──────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final BookingModel booking;
  final Color primary, textColor;

  const _ActionButtons({
    required this.booking,
    required this.primary,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(
        children: [
          if (booking.status == BookingStatus.upcoming) ...[
            _ActionBtn(
              label: 'Reschedule',
              icon: Icons.edit_calendar_rounded,
              color: primary,
              onTap: () {},
            ),
            AppGaps.h10,
            _ActionBtn(
              label: 'Cancel Booking',
              icon: Icons.cancel_outlined,
              color: AppColors.error,
              onTap: () {},
            ),
          ],
          if (booking.status == BookingStatus.completed) ...[
            _ActionBtn(
              label: 'Write a Review',
              icon: Icons.star_rounded,
              color: primary,
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.writeReview, arguments: booking),
            ),
            AppGaps.h10,
            _ActionBtn(
              label: 'Book Again',
              icon: Icons.replay_rounded,
              color: AppColors.secondary,
              onTap: () {},
            ),
          ],
          if (booking.status == BookingStatus.cancelled)
            _ActionBtn(
              label: 'Book Again',
              icon: Icons.replay_rounded,
              color: primary,
              onTap: () {},
            ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.bodyMediumSemibold(color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Color surfaceColor, textColor;

  const _Section({
    required this.title,
    required this.child,
    required this.surfaceColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: EdgeInsets.all(AppSpacing.custom16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmallSemibold(
              color: textColor.withValues(alpha: 0.5),
            ),
          ),
          AppGaps.h10,
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color textColor, primary;

  const _DetailRow(
    this.icon,
    this.label,
    this.value,
    this.textColor,
    this.primary,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.bodySmallMedium(
              color: textColor.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodySmallSemibold(color: textColor),
              textAlign: TextAlign.right,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
