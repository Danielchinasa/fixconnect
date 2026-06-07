import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Determine viewer role so we can show the right "person" info.
    final authState = context.read<AuthCubit>().state;
    final isArtisanView =
        authState is AuthAuthenticated &&
        authState.user?.role == UserRole.artisan;

    // When artisan is viewing: the headline person is the customer.
    final headerName = isArtisanView
        ? (booking.customerName ?? 'Customer')
        : booking.artisanName;

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
                            headerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          AppGaps.h4,
                          Text(
                            '${DateFormat('EEEE, d MMMM yyyy').format(booking.scheduledDate)} · ${booking.timeSlot}',
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

            // ── Person info (artisan for customer; customer for artisan) ──
            SliverToBoxAdapter(
              child: isArtisanView
                  ? _CustomerSection(
                      booking: booking,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      primary: primary,
                    )
                  : _ArtisanSection(
                      booking: booking,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      primary: primary,
                    ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── What needs fixing ────────────────────────────────────────
            if (booking.serviceDescription != null &&
                booking.serviceDescription!.isNotEmpty)
              SliverToBoxAdapter(
                child: _Section(
                  title: 'What Needs Fixing',
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.handyman_rounded,
                          color: primary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppSpacing.custom12),
                      Expanded(
                        child: Text(
                          booking.serviceDescription!,
                          style: AppTextStyles.bodyMediumMedium(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (booking.serviceDescription != null &&
                booking.serviceDescription!.isNotEmpty)
              SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── Job description (artisan notes) ──────────────────────────
            if (booking.notes != null && booking.notes!.isNotEmpty)
              SliverToBoxAdapter(
                child: _Section(
                  title: 'Additional Notes',
                  surfaceColor: surfaceColor,
                  textColor: textColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.notes_rounded,
                          color: primary,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppSpacing.custom12),
                      Expanded(
                        child: Text(
                          booking.notes!,
                          style: AppTextStyles.bodyMediumMedium(
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (booking.notes != null && booking.notes!.isNotEmpty)
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
                isArtisanView: isArtisanView,
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

// ── Artisan section (shown to customers) ──────────────────────────────────
class _ArtisanSection extends StatelessWidget {
  final BookingModel booking;
  final Color surfaceColor, textColor, primary;

  const _ArtisanSection({
    required this.booking,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Artisan',
      surfaceColor: surfaceColor,
      textColor: textColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: booking.artisanBadgeColor.withValues(alpha: 0.15),
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
                  style: AppTextStyles.bodyMediumBold(color: textColor),
                ),
                Text(
                  booking.artisanSpecialty.isNotEmpty
                      ? booking.artisanSpecialty
                      : booking.service,
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
    );
  }
}

// ── Customer section (shown to artisans) ──────────────────────────────────
class _CustomerSection extends StatelessWidget {
  final BookingModel booking;
  final Color surfaceColor, textColor, primary;

  const _CustomerSection({
    required this.booking,
    required this.surfaceColor,
    required this.textColor,
    required this.primary,
  });

  // Deterministic avatar colour from customer name hash (same palette as card)
  Color get _avatarColor {
    const palette = [
      Color(0xFF6366F1),
      Color(0xFF22C55E),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
      Color(0xFF0EA5E9),
    ];
    return palette[(booking.customerName ?? booking.id).hashCode.abs() %
        palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColor;
    final initials = booking.customerInitials ?? '??';
    final customerName = booking.customerName ?? 'Customer';

    return _Section(
      title: 'Customer',
      surfaceColor: surfaceColor,
      textColor: textColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarColor.withValues(alpha: 0.15),
            child: Text(
              initials,
              style: AppTextStyles.bodySmallBold(color: avatarColor),
            ),
          ),
          SizedBox(width: AppSpacing.custom12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: AppTextStyles.bodyMediumBold(color: textColor),
                ),
                Text(
                  booking.customerPhone ?? booking.service,
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
    (Icons.send_rounded, 'Requested'),
    (Icons.request_quote_rounded, 'Quoted'),
    (Icons.check_rounded, 'Confirmed'),
    (Icons.construction_rounded, 'In Progress'),
    (Icons.task_alt_rounded, 'Completed'),
  ];

  int get _activeStep {
    switch (booking.status) {
      case BookingStatus.pending:
        return 0; // request sent, awaiting artisan quote
      case BookingStatus.quoteSent:
        return 1; // artisan replied with quote, awaiting customer
      case BookingStatus.confirmed:
        return 2; // customer accepted quote
      case BookingStatus.inProgress:
        return 3; // artisan working
      case BookingStatus.completed:
        return 4; // done
      case BookingStatus.declined:
      case BookingStatus.cancelled:
        return 0; // terminal — header badge makes the state clear
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
          return SizedBox(
            width: 52,
            child: Column(
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
                    color: done
                        ? Colors.white
                        : textColor.withValues(alpha: 0.3),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _steps[idx].$2,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: done ? primary : textColor.withValues(alpha: 0.4),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
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
  final bool isArtisanView;

  const _ActionButtons({
    required this.booking,
    required this.primary,
    required this.textColor,
    required this.isArtisanView,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(
        children: [
          // ── Artisan view ─────────────────────────────────────────────
          if (isArtisanView) ...[
            if (booking.status == BookingStatus.pending) ...[
              _FilledBtn(
                label: 'Send Quote',
                icon: Icons.request_quote_rounded,
                color: primary,
                onTap: () => _showSendQuoteSheet(context),
              ),
              AppGaps.h10,
              _ActionBtn(
                label: 'Decline Order',
                icon: Icons.close_rounded,
                color: AppColors.error,
                onTap: () => _confirmDecline(context),
              ),
            ],
          ],

          // ── Customer view ────────────────────────────────────────────
          if (!isArtisanView) ...[
            if (booking.status == BookingStatus.quoteSent) ...[
              _FilledBtn(
                label: 'Accept Quote  •  ${booking.totalPrice}',
                icon: Icons.check_circle_rounded,
                color: AppColors.secondary,
                onTap: () => _confirmAcceptQuote(context),
              ),
              AppGaps.h10,
              _ActionBtn(
                label: 'Cancel Booking',
                icon: Icons.cancel_outlined,
                color: AppColors.error,
                onTap: () {},
              ),
            ],
            if (booking.status == BookingStatus.pending ||
                booking.status == BookingStatus.confirmed) ...[
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
        ],
      ),
    );
  }

  void _showSendQuoteSheet(BuildContext context) {
    final pageNavigator = Navigator.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _SendQuoteSheet(booking: booking, pageNavigator: pageNavigator),
    );
  }

  Future<void> _confirmDecline(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Order?'),
        content: const Text(
          'This will notify the customer that you cannot take this job.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await sl<BookingRemoteDataSource>().declineOrder(bookingId: booking.id);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmAcceptQuote(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept Quote?'),
        content: Text(
          'You are agreeing to pay ${booking.totalPrice} for this job.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await sl<BookingRemoteDataSource>().acceptQuote(bookingId: booking.id);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

// ── Filled primary button (artisan CTA) ───────────────────────────────────
class _FilledBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FilledBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: surfaceColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMediumSemibold(color: surfaceColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Send Quote bottom sheet ───────────────────────────────────────────────
class _SendQuoteSheet extends StatefulWidget {
  final BookingModel booking;
  final NavigatorState pageNavigator;
  const _SendQuoteSheet({required this.booking, required this.pageNavigator});

  @override
  State<_SendQuoteSheet> createState() => _SendQuoteSheetState();
}

class _SendQuoteSheetState extends State<_SendQuoteSheet> {
  final _amountController = TextEditingController();
  bool _loading = false;
  String? _error; // inline field validation
  String? _apiError; // server / network error banner

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _amountController.text.trim();
    final amount = num.tryParse(raw.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _apiError = null;
    });
    try {
      await sl<BookingRemoteDataSource>().sendQuote(
        bookingId: widget.booking.id,
        amount: amount,
      );
      if (mounted) {
        Navigator.of(context).pop(); // close sheet
        widget.pageNavigator.pop(); // back to orders list
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _apiError = _friendlyError(e);
        });
      }
    }
  }

  /// Converts a raw exception into a user-readable sentence.
  static String _friendlyError(Object e) {
    final raw = e
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('DioException: ', '')
        .trim();

    // Map known server messages to friendlier copy.
    final lower = raw.toLowerCase();
    if (lower.contains('unauthorized') || lower.contains('401')) {
      return 'Your session has expired. Please log in again.';
    }
    if (lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('socket')) {
      return 'No internet connection. Check your network and try again.';
    }
    if (lower.contains('timeout')) {
      return 'The request timed out. Please try again.';
    }
    if (lower.contains('500') || lower.contains('server error')) {
      return 'Something went wrong on our end. Please try again in a moment.';
    }
    if (lower.contains('404') || lower.contains('not found')) {
      return 'This booking could not be found. It may have been cancelled.';
    }
    // Return the raw message if it\'s already readable (no exception type prefix).
    return raw.isNotEmpty
        ? raw
        : 'An unexpected error occurred. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surfaceColor = context.surfaceColor;
    final textColor = context.textColor;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Send a Quote',
            style: AppTextStyles.bodyLargeBold(color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter the price you want to charge for this job.',
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 20),

          // Amount input
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              prefixText: '₦ ',
              prefixStyle: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              hintText: '0',
              hintStyle: TextStyle(color: textColor.withValues(alpha: 0.3)),
              filled: true,
              fillColor: textColor.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorText: _error,
            ),
          ),

          // API error banner
          if (_apiError != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 18,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _apiError!,
                      style: AppTextStyles.bodySmallRegular(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: surfaceColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: surfaceColor,
                      ),
                    )
                  : Text(
                      'Send Quote',
                      style: AppTextStyles.bodyMediumSemibold(
                        color: surfaceColor,
                      ),
                    ),
            ),
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
