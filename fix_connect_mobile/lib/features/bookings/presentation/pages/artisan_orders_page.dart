import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/cubit/artisan_orders_cubit.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/widgets/artisan_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtisanOrdersPage extends StatefulWidget {
  const ArtisanOrdersPage({super.key});

  @override
  State<ArtisanOrdersPage> createState() => _ArtisanOrdersPageState();
}

class _ArtisanOrdersPageState extends State<ArtisanOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<BookingModel> _all(ArtisanOrdersState state) =>
      state is ArtisanOrdersLoaded ? state.orders : [];

  /// New requests waiting for a quote from the artisan.
  List<BookingModel> _newRequests(ArtisanOrdersState state) =>
      _all(state).where((b) => b.status == BookingStatus.pending).toList();

  /// Bookings that have been quoted, confirmed, or are in progress.
  List<BookingModel> _active(ArtisanOrdersState state) => _all(state)
      .where(
        (b) =>
            b.status == BookingStatus.quoteSent ||
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.inProgress,
      )
      .toList();

  /// Completed, declined, and cancelled bookings.
  List<BookingModel> _history(ArtisanOrdersState state) => _all(state)
      .where(
        (b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.declined ||
            b.status == BookingStatus.cancelled,
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ArtisanOrdersCubit>().load();
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

    return BlocBuilder<ArtisanOrdersCubit, ArtisanOrdersState>(
      builder: (context, state) {
        final newRequests = _newRequests(state);
        final active = _active(state);
        final history = _history(state);
        final isLoading = state is ArtisanOrdersLoading;
        final error = state is ArtisanOrdersError ? state.message : null;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  AppSpacing.custom8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Orders',
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                          Text(
                            'Manage your incoming booking requests',
                            style: AppTextStyles.bodySmallRegular(
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Refresh button
                    GestureDetector(
                      onTap: () => context.read<ArtisanOrdersCubit>().load(),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Summary stats row ────────────────────────────────────
              if (state is ArtisanOrdersLoaded) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.custom16,
                  ),
                  child: Row(
                    children: [
                      _StatChip(
                        label: 'New',
                        count: newRequests.length,
                        color: const Color(0xFF0dd0f0),
                        isDark: isDark,
                      ),
                      SizedBox(width: AppSpacing.custom8),
                      _StatChip(
                        label: 'Active',
                        count: active.length,
                        color: const Color(0xFFFF9500),
                        isDark: isDark,
                      ),
                      SizedBox(width: AppSpacing.custom8),
                      _StatChip(
                        label: 'Done',
                        count: history
                            .where((b) => b.status == BookingStatus.completed)
                            .length,
                        color: const Color(0xFF22C55E),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                AppGaps.h16,
              ] else
                AppGaps.h8,

              // ─── Tab bar ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
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
                    labelColor: surfaceColor,
                    unselectedLabelColor: textColor.withValues(alpha: 0.55),
                    labelStyle: AppTextStyles.bodySmallSemibold(),
                    unselectedLabelStyle: AppTextStyles.bodySmallRegular(),
                    tabs: [
                      _TabLabel(
                        label: 'New',
                        count: newRequests.length,
                        highlight: newRequests.isNotEmpty,
                      ),
                      _TabLabel(label: 'Active', count: active.length),
                      _TabLabel(label: 'History', count: history.length),
                    ],
                  ),
                ),
              ),

              AppGaps.h16,

              // ─── Tab body ─────────────────────────────────────────────
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? _ErrorView(
                        message: error,
                        primary: primary,
                        textColor: textColor,
                        onRetry: () =>
                            context.read<ArtisanOrdersCubit>().load(),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _OrderList(
                            orders: newRequests,
                            textColor: textColor,
                            surfaceColor: surfaceColor,
                            isDark: isDark,
                            primary: primary,
                            emptyIcon: Icons.inbox_rounded,
                            emptyMessage: 'No new requests yet',
                            emptySubtitle:
                                'New customer bookings will appear here',
                          ),
                          _OrderList(
                            orders: active,
                            textColor: textColor,
                            surfaceColor: surfaceColor,
                            isDark: isDark,
                            primary: primary,
                            emptyIcon: Icons.construction_rounded,
                            emptyMessage: 'No active jobs',
                            emptySubtitle:
                                'Confirmed and in-progress bookings show here',
                          ),
                          _OrderList(
                            orders: history,
                            textColor: textColor,
                            surfaceColor: surfaceColor,
                            isDark: isDark,
                            primary: primary,
                            emptyIcon: Icons.history_rounded,
                            emptyMessage: 'No history yet',
                            emptySubtitle:
                                'Completed and cancelled orders will appear here',
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final int count;
  final bool highlight;

  const _TabLabel({
    required this.label,
    required this.count,
    this.highlight = false,
  });

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
                color: highlight
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: highlight ? const Color(0xFF0dd0f0) : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<BookingModel> orders;
  final Color textColor, surfaceColor, primary;
  final bool isDark;
  final IconData emptyIcon;
  final String emptyMessage, emptySubtitle;

  const _OrderList({
    required this.orders,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    required this.primary,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyState(
        icon: emptyIcon,
        message: emptyMessage,
        subtitle: emptySubtitle,
        textColor: textColor,
        primary: primary,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: AppSpacing.custom16),
      itemCount: orders.length,
      itemBuilder: (_, i) => ArtisanOrderCard(
        booking: orders[i],
        textColor: textColor,
        surfaceColor: surfaceColor,
        isDark: isDark,
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRoutes.bookingDetail, arguments: orders[i]),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message, subtitle;
  final Color textColor, primary;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: primary.withValues(alpha: 0.5),
              ),
            ),
            AppGaps.h16,
            Text(
              message,
              style: AppTextStyles.bodyMediumSemibold(
                color: textColor.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            AppGaps.h8,
            Text(
              subtitle,
              style: AppTextStyles.bodySmallRegular(
                color: textColor.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Color primary, textColor;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.primary,
    required this.textColor,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: primary.withValues(alpha: 0.4),
          ),
          AppGaps.h8,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular(
              color: textColor.withValues(alpha: 0.55),
            ),
          ),
          AppGaps.h16,
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.bodyMediumSemibold(color: primary),
            ),
          ),
        ],
      ),
    );
  }
}
