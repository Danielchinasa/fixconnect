import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/data/datasources/bookings_mock_datasource.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';

// 📚 CONCEPT: Nested TabBar inside IndexedStack
//
// The outer IndexedStack (in HomePage) tracks which bottom-nav tab is active.
// BookingsPage itself uses a SECOND TabController for Upcoming/Done/Cancelled.
// This is perfectly fine — Flutter supports nested tab controllers as long as
// each controller is owned by its own State and disposed when the widget is removed.
//
// SingleTickerProviderStateMixin — provides a single "ticker" (animation clock)
// required by TabController for driving tab-switching animations.
class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _allBookings = BookingsMockDatasource.getBookings();

  List<BookingModel> get _upcoming => _allBookings
      .where(
        (b) =>
            b.status == BookingStatus.upcoming ||
            b.status == BookingStatus.inProgress,
      )
      .toList();

  List<BookingModel> get _completed =>
      _allBookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingModel> get _cancelled =>
      _allBookings.where((b) => b.status == BookingStatus.cancelled).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final primary = theme.colorScheme.primary;

    // 📚 CONCEPT: No Scaffold here — the outer shell (HomePage) already provides one.
    // Each tab widget is just a subtree. Using SafeArea ensures content stays
    // below the status bar without double-nesting Scaffolds.
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Page title ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.md,
              AppSpacing.pagePadding,
              AppSpacing.sm,
            ),
            child: Text(
              'My Bookings',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),

          // ─── Pill-style TabBar ──────────────────────────────────
          // 📚 CONCEPT: Pill TabBar
          // We wrap the TabBar in a Container to give it a rounded background.
          // Setting indicator to a BoxDecoration with the same borderRadius as
          // the container creates the "sliding pill" effect.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppSpacing.custom12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(AppSpacing.custom12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: isDark ? AppColors.darkBackground : Colors.white,
                unselectedLabelColor: textColor.withValues(alpha: 0.55),
                labelStyle: AppTextStyles.bodySmallSemibold(),
                unselectedLabelStyle: AppTextStyles.bodySmallRegular(),
                tabs: [
                  _TabLabel(label: 'Upcoming', count: _upcoming.length),
                  _TabLabel(label: 'Done', count: _completed.length),
                  _TabLabel(label: 'Cancelled', count: _cancelled.length),
                ],
              ),
            ),
          ),

          AppGaps.hMd,

          // ─── Tab body ────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BookingList(
                  bookings: _upcoming,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                  emptyMessage: 'No upcoming bookings',
                  emptyIcon: Icons.calendar_today_outlined,
                  primary: primary,
                ),
                _BookingList(
                  bookings: _completed,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                  emptyMessage: 'No completed bookings yet',
                  emptyIcon: Icons.check_circle_outline_rounded,
                  primary: primary,
                ),
                _BookingList(
                  bookings: _cancelled,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                  emptyMessage: 'No cancelled bookings',
                  emptyIcon: Icons.cancel_outlined,
                  primary: primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Tab label with count badge ─────────────────────────────────
class _TabLabel extends StatelessWidget {
  final String label;
  final int count;
  const _TabLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Private: List of booking cards, or empty state ──────────────────────
class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;
  final bool isDark;
  final String emptyMessage;
  final IconData emptyIcon;

  const _BookingList({
    required this.bookings,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 56, color: primary.withValues(alpha: 0.3)),
            AppGaps.hMd,
            Text(
              emptyMessage,
              style: AppTextStyles.bodyMediumRegular(
                color: textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      // Extra bottom padding = nav bar (~60) + system home indicator
      padding: EdgeInsets.only(
        top: 4,
        bottom: MediaQuery.of(context).padding.bottom + 72,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) => BookingCard(
        booking: bookings[index],
        textColor: textColor,
        surfaceColor: surfaceColor,
        isDark: isDark,
      ),
    );
  }
}
