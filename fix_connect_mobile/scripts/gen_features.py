"""Generate all new feature screens: notifications, booking flow,
booking detail, write review, search results."""
import os

BASE = '/Applications/MAMP/htdocs/fixconnect/fix_connect_mobile/lib'

def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    lines = content.count('\n')
    print(f'✓ {path.replace(BASE + "/", "")} ({lines} lines)')


# ══════════════════════════════════════════════════════════════════════════════
# 1. Notification model
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/notifications/data/models/notification_model.dart', """
import 'package:flutter/material.dart';

enum NotificationType {
  bookingConfirmed,
  bookingReminder,
  payment,
  promo,
  reviewRequest,
}

extension NotificationTypeX on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.bookingConfirmed: return Icons.check_circle_rounded;
      case NotificationType.bookingReminder:  return Icons.schedule_rounded;
      case NotificationType.payment:          return Icons.payments_rounded;
      case NotificationType.promo:            return Icons.local_offer_rounded;
      case NotificationType.reviewRequest:    return Icons.star_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.bookingConfirmed: return const Color(0xFF22C55E);
      case NotificationType.bookingReminder:  return const Color(0xFF0dd0f0);
      case NotificationType.payment:          return const Color(0xFF8B5CF6);
      case NotificationType.promo:            return const Color(0xFFFF9500);
      case NotificationType.reviewRequest:    return const Color(0xFFFFB800);
    }
  }
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 2. Notifications mock datasource
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/notifications/data/datasources/notifications_mock_datasource.dart', """
import 'package:fix_connect_mobile/features/notifications/data/models/notification_model.dart';

class NotificationsMockDatasource {
  NotificationsMockDatasource._();

  static List<NotificationModel> getNotifications() => [
    NotificationModel(
      id: 'n1',
      type: NotificationType.bookingConfirmed,
      title: 'Booking Confirmed!',
      body: 'Your booking with Emeka Okafor for Pipe Repair is confirmed for Fri, 25 Apr at 10:00 AM.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n2',
      type: NotificationType.bookingReminder,
      title: 'Booking Tomorrow',
      body: "Don't forget — Amina Bello is coming for Electrical Wiring tomorrow at 2:00 PM.",
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n3',
      type: NotificationType.payment,
      title: 'Payment Successful',
      body: '₦7,500 payment for Pipe Repair was processed successfully.',
      time: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n4',
      type: NotificationType.reviewRequest,
      title: 'How was the service?',
      body: 'Rate your experience with Fatima Musa for Deep Cleaning.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n5',
      type: NotificationType.promo,
      title: '20% off this weekend!',
      body: 'Book any cleaning service this weekend and save 20%. Use code CLEAN20.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n6',
      type: NotificationType.bookingConfirmed,
      title: 'Booking Request Sent',
      body: 'Your request with Chukwudi Nze for Furniture Assembly has been sent.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n7',
      type: NotificationType.payment,
      title: 'Refund Processed',
      body: '₦15,000 refund for the cancelled Interior Painting booking is complete.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ];
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 3. Notifications page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/notifications/presentation/pages/notifications_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/notifications/data/datasources/notifications_mock_datasource.dart';
import 'package:fix_connect_mobile/features/notifications/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<NotificationModel> _notifications =
      NotificationsMockDatasource.getNotifications();

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() =>
      setState(() { for (final n in _notifications) n.isRead = true; });

  void _markRead(String id) => setState(
      () => _notifications.firstWhere((n) => n.id == id).isRead = true);

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  String _timeLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  List<NotificationModel> get _today =>
      _notifications.where((n) => _isToday(n.time)).toList();
  List<NotificationModel> get _earlier =>
      _notifications.where((n) => !_isToday(n.time)).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final primary = context.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Notifications', style: AppTextStyles.header4Bold(color: textColor)),
              if (_unreadCount > 0)
                Text('$_unreadCount unread',
                    style: AppTextStyles.bodySmallRegular(color: primary)),
            ],
          ),
          actions: [
            if (_unreadCount > 0)
              TextButton(
                onPressed: _markAllRead,
                child: Text('Mark all read',
                    style: AppTextStyles.bodySmallSemibold(color: primary)),
              ),
          ],
        ),
        body: _notifications.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.notifications_none_rounded,
                      size: 56, color: primary.withValues(alpha: 0.3)),
                  AppGaps.h16,
                  Text('No notifications yet',
                      style: AppTextStyles.bodyMediumRegular(
                          color: textColor.withValues(alpha: 0.5))),
                ]),
              )
            : ListView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16),
                children: [
                  if (_today.isNotEmpty) ...[
                    _SectionLabel(label: 'Today', textColor: textColor),
                    ..._today.map((n) => _NotifTile(
                          notification: n,
                          timeLabel: _timeLabel(n.time),
                          onTap: () => _markRead(n.id),
                        )),
                  ],
                  if (_earlier.isNotEmpty) ...[
                    _SectionLabel(label: 'Earlier', textColor: textColor),
                    ..._earlier.map((n) => _NotifTile(
                          notification: n,
                          timeLabel: _timeLabel(n.time),
                          onTap: () => _markRead(n.id),
                        )),
                  ],
                ],
              ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textColor;

  const _SectionLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, AppSpacing.custom16,
          AppSpacing.custom16, AppSpacing.custom8),
      child: Text(label,
          style: AppTextStyles.bodySmallSemibold(
              color: textColor.withValues(alpha: 0.5))),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel notification;
  final String timeLabel;
  final VoidCallback onTap;

  const _NotifTile(
      {required this.notification,
      required this.timeLabel,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isDark = context.isDark;
    final typeColor = notification.type.color;
    final unread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.custom16, vertical: AppSpacing.custom4),
        padding: EdgeInsets.all(AppSpacing.custom14),
        decoration: BoxDecoration(
          color: unread
              ? primary.withValues(alpha: isDark ? 0.08 : 0.05)
              : surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
          border: unread
              ? Border.all(color: primary.withValues(alpha: 0.2), width: 1)
              : null,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle),
            child: Icon(notification.type.icon, color: typeColor, size: 20),
          ),
          SizedBox(width: AppSpacing.custom12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: unread
                        ? AppTextStyles.bodyMediumBold(color: textColor)
                        : AppTextStyles.bodyMediumMedium(color: textColor),
                  ),
                ),
                if (unread)
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: primary, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 4),
              Text(notification.body,
                  style: AppTextStyles.bodySmallRegular(
                      color: textColor.withValues(alpha: 0.6)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(timeLabel,
                  style: AppTextStyles.bodySmallRegular(
                      color: textColor.withValues(alpha: 0.4))),
            ]),
          ),
        ]),
      ),
    );
  }
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 4. Booking flow page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/bookings/presentation/pages/booking_flow_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BookingFlowPage extends StatefulWidget {
  final ArtisanModel artisan;

  const BookingFlowPage({super.key, required this.artisan});

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  final _pageController = PageController();
  int _step = 0;

  // Step 0
  DateTime? _selectedDate;
  String? _selectedSlot;

  // Step 1
  final _notesCtrl = TextEditingController();
  String _selectedAddress = 'Home';

  // Step 2
  int _selectedPayment = 0;

  static const _timeSlots = [
    '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM',
    '5:00 PM', '6:00 PM',
  ];

  static const _addresses = [
    ('Home', Icons.home_rounded, '14 Admiralty Way, Lekki Phase 1, Lagos'),
    ('Work', Icons.business_center_rounded, '1A Adeola Odeku St, Victoria Island'),
  ];

  static const _payments = [
    ('Visa •••• 4242', Icons.credit_card_rounded),
    ('Mastercard •••• 1234', Icons.credit_card_rounded),
  ];

  List<DateTime> get _dates =>
      List.generate(14, (i) => DateTime.now().add(Duration(days: i)));

  bool get _canProceed =>
      _step != 0 || (_selectedDate != null && _selectedSlot != null);

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
      _pageController.animateToPage(_step,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _showConfirmSheet();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.animateToPage(_step,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  void _showConfirmSheet() {
    final primary = context.primary;
    final textColor = context.textColor;
    final bgColor = context.bgColor;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_rounded,
                color: AppColors.secondary, size: 32),
          ),
          AppGaps.h16,
          Text('Booking Confirmed!',
              style: AppTextStyles.header4Bold(color: textColor)),
          AppGaps.h8,
          Text(
            'Your booking with ${widget.artisan.name} has been sent.\\nYou will receive a confirmation shortly.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular(
                color: textColor.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 28),
          ButtonPrimary(
            text: 'View My Bookings',
            bgColor: primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          AppGaps.h10,
          ButtonPrimary(
            text: 'Back to Artisan',
            bgColor: context.surfaceColor,
            textColor: primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    const stepTitles = ['Date & Time', 'Service Details', 'Review & Pay'];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: _back,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Book ${widget.artisan.name.split(' ').first}',
                  style: AppTextStyles.header4Bold(color: textColor)),
              Text('Step ${_step + 1} of 3 · ${stepTitles[_step]}',
                  style: AppTextStyles.bodySmallRegular(
                      color: textColor.withValues(alpha: 0.5))),
            ],
          ),
        ),
        body: Column(children: [
          LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: surfaceColor,
            valueColor: AlwaysStoppedAnimation<Color>(primary),
            minHeight: 3,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _DateTimeStep(
                  dates: _dates,
                  selectedDate: _selectedDate,
                  selectedSlot: _selectedSlot,
                  timeSlots: _timeSlots,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  primary: primary,
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                  onSlotSelected: (s) => setState(() => _selectedSlot = s),
                ),
                _DetailsStep(
                  notesCtrl: _notesCtrl,
                  selectedAddress: _selectedAddress,
                  addresses: _addresses,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  primary: primary,
                  isDark: isDark,
                  onAddressSelected: (a) => setState(() => _selectedAddress = a),
                ),
                _SummaryStep(
                  artisan: widget.artisan,
                  selectedDate: _selectedDate,
                  selectedSlot: _selectedSlot ?? '–',
                  selectedAddress: _selectedAddress,
                  notes: _notesCtrl.text,
                  payments: _payments,
                  selectedPayment: _selectedPayment,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                  primary: primary,
                  isDark: isDark,
                  onPaymentSelected: (i) => setState(() => _selectedPayment = i),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacing.custom16,
                AppSpacing.custom12,
                AppSpacing.custom16,
                MediaQuery.of(context).padding.bottom + AppSpacing.custom12),
            decoration: BoxDecoration(
              color: bgColor,
              border:
                  Border(top: BorderSide(color: textColor.withValues(alpha: 0.08))),
            ),
            child: ButtonPrimary(
              text: _step == 2 ? 'Confirm Booking' : 'Continue',
              bgColor: primary,
              enabled: _canProceed,
              onTap: _next,
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Step 0: Date & Time ───────────────────────────────────────────────────────
class _DateTimeStep extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final List<String> timeSlots;
  final Color textColor, surfaceColor, primary;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onSlotSelected;

  const _DateTimeStep({
    required this.dates,
    required this.selectedDate,
    required this.selectedSlot,
    required this.timeSlots,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.onDateSelected,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppGaps.h8,
        Text('Select a date',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => AppGaps.w8,
            itemCount: dates.length,
            itemBuilder: (_, i) {
              final d = dates[i];
              final sel = selectedDate != null &&
                  selectedDate!.day == d.day &&
                  selectedDate!.month == d.month;
              return GestureDetector(
                onTap: () => onDateSelected(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  decoration: BoxDecoration(
                    color: sel ? primary : surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('E').format(d),
                          style: AppTextStyles.bodySmallMedium(
                              color: sel
                                  ? Colors.white
                                  : textColor.withValues(alpha: 0.5))),
                      const SizedBox(height: 4),
                      Text('${d.day}',
                          style: AppTextStyles.bodyMediumBold(
                              color: sel ? Colors.white : textColor)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        AppGaps.h24,
        Text('Select a time',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: timeSlots.map((slot) {
            final sel = selectedSlot == slot;
            return GestureDetector(
              onTap: () => onSlotSelected(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? primary : surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? primary : textColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(slot,
                    style: AppTextStyles.bodySmallSemibold(
                        color: sel ? Colors.white : textColor)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ── Step 1: Service Details ───────────────────────────────────────────────────
class _DetailsStep extends StatelessWidget {
  final TextEditingController notesCtrl;
  final String selectedAddress;
  final List<(String, IconData, String)> addresses;
  final Color textColor, surfaceColor, primary;
  final bool isDark;
  final ValueChanged<String> onAddressSelected;

  const _DetailsStep({
    required this.notesCtrl,
    required this.selectedAddress,
    required this.addresses,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppGaps.h8,
        Text('Describe what you need',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        const SizedBox(height: 4),
        Text('Help the artisan prepare by describing the job.',
            style: AppTextStyles.bodySmallRegular(
                color: textColor.withValues(alpha: 0.55))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: surfaceColor, borderRadius: BorderRadius.circular(14)),
          child: TextField(
            controller: notesCtrl,
            maxLines: 4,
            style: AppTextStyles.bodyMediumRegular(color: textColor),
            cursorColor: primary,
            decoration: InputDecoration(
              hintText: 'e.g. Kitchen sink has been leaking for 2 days...',
              hintStyle: AppTextStyles.bodyMediumRegular(
                  color: textColor.withValues(alpha: 0.35)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        AppGaps.h24,
        Text('Service location',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        const SizedBox(height: 12),
        ...addresses.map((addr) {
          final sel = selectedAddress == addr.$1;
          return GestureDetector(
            onTap: () => onAddressSelected(addr.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(AppSpacing.custom14),
              decoration: BoxDecoration(
                color: sel ? primary.withValues(alpha: 0.08) : surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: sel ? primary : textColor.withValues(alpha: 0.1),
                  width: sel ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                Icon(addr.$2,
                    color: sel ? primary : textColor.withValues(alpha: 0.5),
                    size: 22),
                SizedBox(width: AppSpacing.custom12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(addr.$1,
                            style: AppTextStyles.bodyMediumBold(
                                color: sel ? primary : textColor)),
                        Text(addr.$3,
                            style: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.55))),
                      ]),
                ),
                if (sel)
                  Icon(Icons.check_circle_rounded, color: primary, size: 20),
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

// ── Step 2: Summary & Pay ─────────────────────────────────────────────────────
class _SummaryStep extends StatelessWidget {
  final ArtisanModel artisan;
  final DateTime? selectedDate;
  final String selectedSlot, selectedAddress, notes;
  final List<(String, IconData)> payments;
  final int selectedPayment;
  final Color textColor, surfaceColor, primary;
  final bool isDark;
  final ValueChanged<int> onPaymentSelected;

  const _SummaryStep({
    required this.artisan,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedAddress,
    required this.notes,
    required this.payments,
    required this.selectedPayment,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate != null
        ? DateFormat('EEE, d MMM yyyy').format(selectedDate!)
        : '–';

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.custom16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppGaps.h8,
        Text('Review your booking',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h16,
        // Artisan card
        Container(
          padding: EdgeInsets.all(AppSpacing.custom14),
          decoration: BoxDecoration(
              color: surfaceColor, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: artisan.badgeColor.withValues(alpha: 0.15),
              child: Text(artisan.initials,
                  style: AppTextStyles.bodySmallBold(color: artisan.badgeColor)),
            ),
            SizedBox(width: AppSpacing.custom12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(artisan.name,
                          style: AppTextStyles.bodyMediumBold(color: textColor)),
                      if (artisan.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified_rounded, color: primary, size: 14),
                      ],
                    ]),
                    Text(artisan.specialty,
                        style: AppTextStyles.bodySmallRegular(
                            color: textColor.withValues(alpha: 0.55))),
                  ]),
            ),
            Row(children: [
              const Icon(Icons.star_rounded,
                  color: Color(0xFFFFB800), size: 14),
              const SizedBox(width: 3),
              Text(artisan.rating.toStringAsFixed(1),
                  style: AppTextStyles.bodySmallBold(color: textColor)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        // Detail rows
        Container(
          padding: EdgeInsets.all(AppSpacing.custom14),
          decoration: BoxDecoration(
              color: surfaceColor, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            _SummaryRow(Icons.calendar_today_rounded, 'Date', dateStr,
                textColor, primary),
            _Divider(textColor),
            _SummaryRow(Icons.access_time_rounded, 'Time', selectedSlot,
                textColor, primary),
            _Divider(textColor),
            _SummaryRow(Icons.location_on_rounded, 'Location', selectedAddress,
                textColor, primary),
            if (notes.trim().isNotEmpty) ...[
              _Divider(textColor),
              _SummaryRow(Icons.notes_rounded, 'Notes', notes.trim(),
                  textColor, primary),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        // Price breakdown
        Container(
          padding: EdgeInsets.all(AppSpacing.custom14),
          decoration: BoxDecoration(
              color: surfaceColor, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            Row(children: [
              Text('Starting price',
                  style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withValues(alpha: 0.65))),
              const Spacer(),
              Text(artisan.startingPrice,
                  style: AppTextStyles.bodyMediumMedium(color: textColor)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Text('Platform fee',
                  style: AppTextStyles.bodyMediumRegular(
                      color: textColor.withValues(alpha: 0.65))),
              const Spacer(),
              Text('₦500',
                  style: AppTextStyles.bodyMediumMedium(color: textColor)),
            ]),
            const SizedBox(height: 12),
            Divider(color: textColor.withValues(alpha: 0.1)),
            const SizedBox(height: 8),
            Row(children: [
              Text('Total estimate',
                  style: AppTextStyles.bodyMediumBold(color: textColor)),
              const Spacer(),
              Text(artisan.startingPrice,
                  style: AppTextStyles.bodyLargeBold(color: primary)),
            ]),
          ]),
        ),
        AppGaps.h16,
        Text('Payment Method',
            style: AppTextStyles.bodyLargeBold(color: textColor)),
        AppGaps.h10,
        ...List.generate(payments.length, (i) {
          final sel = selectedPayment == i;
          return GestureDetector(
            onTap: () => onPaymentSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: sel ? primary.withValues(alpha: 0.08) : surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: sel ? primary : textColor.withValues(alpha: 0.1),
                  width: sel ? 1.5 : 1,
                ),
              ),
              child: Row(children: [
                Icon(payments[i].$2,
                    color: sel
                        ? primary
                        : textColor.withValues(alpha: 0.5),
                    size: 22),
                SizedBox(width: AppSpacing.custom12),
                Expanded(
                  child: Text(payments[i].$1,
                      style: AppTextStyles.bodyMediumMedium(
                          color: sel ? primary : textColor)),
                ),
                if (sel)
                  Icon(Icons.check_circle_rounded, color: primary, size: 20),
              ]),
            ),
          );
        }),
        AppGaps.h16,
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color textColor, primary;

  const _SummaryRow(
      this.icon, this.label, this.value, this.textColor, this.primary);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, color: primary, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: AppTextStyles.bodySmallMedium(
                color: textColor.withValues(alpha: 0.5))),
        const Spacer(),
        Flexible(
          child: Text(value,
              style: AppTextStyles.bodySmallSemibold(color: textColor),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
      ]),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color textColor;

  const _Divider(this.textColor);

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: textColor.withValues(alpha: 0.08));
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 5. Booking detail page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/bookings/presentation/pages/booking_detail_page.dart', """
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
    final isDark = context.isDark;
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
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
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
                        statusColor
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
                          AppSpacing.custom20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(booking.status.icon,
                                  size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(booking.status.label,
                                  style: AppTextStyles.bodySmallSemibold(
                                      color: Colors.white)),
                            ]),
                          ),
                          AppGaps.h8,
                          Text(booking.service,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1)),
                          AppGaps.h4,
                          Text(
                            DateFormat('EEEE, d MMMM yyyy')
                                    .format(booking.scheduledDate) +
                                ' · ' +
                                booking.timeSlot,
                            style: AppTextStyles.bodySmallMedium(
                                color: Colors.white.withValues(alpha: 0.8)),
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
                  surfaceColor: surfaceColor),
            ),
            SliverToBoxAdapter(child: AppGaps.h16),

            // ── Artisan info ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Artisan',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Row(children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        booking.artisanBadgeColor.withValues(alpha: 0.15),
                    child: Text(booking.artisanInitials,
                        style: AppTextStyles.bodySmallBold(
                            color: booking.artisanBadgeColor)),
                  ),
                  SizedBox(width: AppSpacing.custom12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking.artisanName,
                              style:
                                  AppTextStyles.bodyMediumBold(color: textColor)),
                          Text(booking.artisanSpecialty,
                              style: AppTextStyles.bodySmallRegular(
                                  color: textColor.withValues(alpha: 0.55))),
                        ]),
                  ),
                  Row(children: [
                    _CircleBtn(
                        icon: Icons.call_rounded,
                        color: AppColors.secondary,
                        onTap: () {}),
                    const SizedBox(width: 8),
                    _CircleBtn(
                        icon: Icons.chat_bubble_rounded,
                        color: primary,
                        onTap: () {}),
                  ]),
                ]),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── Service details ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Service Details',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Column(children: [
                  _DetailRow(Icons.build_circle_outlined, 'Service',
                      booking.service, textColor, primary),
                  _DetailRow(
                      Icons.calendar_today_rounded,
                      'Date',
                      DateFormat('EEE, d MMM yyyy')
                          .format(booking.scheduledDate),
                      textColor,
                      primary),
                  _DetailRow(Icons.access_time_rounded, 'Time',
                      booking.timeSlot, textColor, primary),
                  _DetailRow(Icons.payments_rounded, 'Total',
                      booking.totalPrice, textColor, primary),
                  if (booking.notes != null)
                    _DetailRow(Icons.notes_rounded, 'Notes', booking.notes!,
                        textColor, primary),
                ]),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),

            // ── Address ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _Section(
                title: 'Address',
                surfaceColor: surfaceColor,
                textColor: textColor,
                child: Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.location_on_rounded,
                        color: primary, size: 18),
                  ),
                  SizedBox(width: AppSpacing.custom12),
                  Expanded(
                    child: Text(booking.address,
                        style:
                            AppTextStyles.bodyMediumMedium(color: textColor)),
                  ),
                ]),
              ),
            ),
            SliverToBoxAdapter(child: AppGaps.h24),

            // ── Action buttons ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: _ActionButtons(
                  booking: booking,
                  primary: primary,
                  textColor: textColor),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 24),
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

  const _StatusTimeline(
      {required this.booking,
      required this.textColor,
      required this.surfaceColor});

  static const _steps = [
    (Icons.check_rounded, 'Confirmed'),
    (Icons.person_rounded, 'Assigned'),
    (Icons.construction_rounded, 'In Progress'),
    (Icons.check_circle_rounded, 'Completed'),
  ];

  int get _activeStep {
    switch (booking.status) {
      case BookingStatus.upcoming:   return 1;
      case BookingStatus.inProgress: return 2;
      case BookingStatus.completed:  return 3;
      case BookingStatus.cancelled:  return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final active = _activeStep;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: EdgeInsets.symmetric(
          vertical: AppSpacing.custom16, horizontal: AppSpacing.custom8),
      decoration: BoxDecoration(
          color: surfaceColor, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = i ~/ 2 < active;
            return Expanded(
              child: Container(
                  height: 2,
                  color: done
                      ? primary
                      : textColor.withValues(alpha: 0.1)),
            );
          }
          final idx = i ~/ 2;
          final done = idx <= active;
          return Column(mainAxisSize: MainAxisSize.min, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: done
                    ? primary
                    : textColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(_steps[idx].$1,
                  size: 15,
                  color: done
                      ? Colors.white
                      : textColor.withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 6),
            Text(_steps[idx].$2,
                style: AppTextStyles.bodySmallRegular(
                    color: done
                        ? primary
                        : textColor.withValues(alpha: 0.4)),
                textAlign: TextAlign.center),
          ]);
        }),
      ),
    );
  }
}

// ── Action buttons ──────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final BookingModel booking;
  final Color primary, textColor;

  const _ActionButtons(
      {required this.booking, required this.primary, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Column(children: [
        if (booking.status == BookingStatus.upcoming) ...[
          _ActionBtn(
              label: 'Reschedule',
              icon: Icons.edit_calendar_rounded,
              color: primary,
              onTap: () {}),
          AppGaps.h10,
          _ActionBtn(
              label: 'Cancel Booking',
              icon: Icons.cancel_outlined,
              color: AppColors.error,
              onTap: () {}),
        ],
        if (booking.status == BookingStatus.completed) ...[
          _ActionBtn(
            label: 'Write a Review',
            icon: Icons.star_rounded,
            color: primary,
            onTap: () => Navigator.of(context)
                .pushNamed(AppRoutes.writeReview, arguments: booking),
          ),
          AppGaps.h10,
          _ActionBtn(
              label: 'Book Again',
              icon: Icons.replay_rounded,
              color: AppColors.secondary,
              onTap: () {}),
        ],
        if (booking.status == BookingStatus.cancelled)
          _ActionBtn(
              label: 'Book Again',
              icon: Icons.replay_rounded,
              color: primary,
              onTap: () {}),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

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
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodyMediumSemibold(color: color)),
        ]),
      ),
    );
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Color surfaceColor, textColor;

  const _Section(
      {required this.title,
      required this.child,
      required this.surfaceColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      padding: EdgeInsets.all(AppSpacing.custom16),
      decoration: BoxDecoration(
          color: surfaceColor, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: AppTextStyles.bodySmallSemibold(
                color: textColor.withValues(alpha: 0.5))),
        AppGaps.h10,
        child,
      ]),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color textColor, primary;

  const _DetailRow(
      this.icon, this.label, this.value, this.textColor, this.primary);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, color: primary, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: AppTextStyles.bodySmallMedium(
                color: textColor.withValues(alpha: 0.5))),
        const Spacer(),
        Flexible(
          child: Text(value,
              style: AppTextStyles.bodySmallSemibold(color: textColor),
              textAlign: TextAlign.right,
              maxLines: 2),
        ),
      ]),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 6. Write review page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/bookings/presentation/pages/write_review_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteReviewPage extends StatefulWidget {
  final BookingModel booking;

  const WriteReviewPage({super.key, required this.booking});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();

  static const _labels = ['', 'Terrible', 'Poor', 'Okay', 'Good', 'Excellent!'];

  void _submit() {
    if (_rating == 0) return;
    final primary = context.primary;
    final textColor = context.textColor;
    final bgColor = context.bgColor;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: const Icon(Icons.star_rounded,
                color: Color(0xFFFFB800), size: 32),
          ),
          AppGaps.h16,
          Text('Review Submitted!',
              style: AppTextStyles.header4Bold(color: textColor)),
          AppGaps.h8,
          Text(
            'Thanks for rating ${widget.booking.artisanName.split(' ').first}. '
            'Your feedback helps other customers.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular(
                color: textColor.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 28),
          ButtonPrimary(
            text: 'Done',
            bgColor: primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Write a Review',
              style: AppTextStyles.header4Bold(color: textColor)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.custom24),
          child: Column(children: [
            // Artisan identity card
            Container(
              padding: EdgeInsets.all(AppSpacing.custom16),
              decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      widget.booking.artisanBadgeColor.withValues(alpha: 0.15),
                  child: Text(widget.booking.artisanInitials,
                      style: AppTextStyles.bodyMediumBold(
                          color: widget.booking.artisanBadgeColor)),
                ),
                SizedBox(width: AppSpacing.custom14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.booking.artisanName,
                            style: AppTextStyles.bodyLargeBold(color: textColor)),
                        Text(widget.booking.service,
                            style: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.55))),
                      ]),
                ),
              ]),
            ),
            AppGaps.h32,

            // Star rating
            Text('How would you rate the service?',
                style: AppTextStyles.bodyLargeBold(color: textColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _rating;
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: filled
                          ? const Color(0xFFFFB800)
                          : textColor.withValues(alpha: 0.25),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: _rating > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Text(_labels[_rating],
                  style: AppTextStyles.bodyLargeSemibold(
                      color: const Color(0xFFFFB800))),
            ),
            const SizedBox(height: 28),

            // Comment
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Add a comment (optional)',
                  style: AppTextStyles.bodyMediumSemibold(color: textColor)),
            ),
            AppGaps.h10,
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _commentCtrl,
                maxLines: 4,
                style: AppTextStyles.bodyMediumRegular(color: textColor),
                cursorColor: primary,
                decoration: InputDecoration(
                  hintText: 'Share your experience with other customers...',
                  hintStyle: AppTextStyles.bodyMediumRegular(
                      color: textColor.withValues(alpha: 0.35)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            AppGaps.h32,

            ButtonPrimary(
              text: 'Submit Review',
              bgColor: primary,
              enabled: _rating > 0,
              onTap: _submit,
            ),
          ]),
        ),
      ),
    );
  }
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 7. Search results page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/home/presentation/pages/search_results_page.dart', """
import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _Sort { relevance, ratingDesc, priceAsc }

class SearchResultsPage extends StatefulWidget {
  final String? initialQuery;

  const SearchResultsPage({super.key, this.initialQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _ctrl;
  String _query = '';
  bool _verifiedOnly = false;
  double _minRating = 0;
  _Sort _sort = _Sort.relevance;

  final List<ArtisanModel> _all = HomeMockDatasource.getTopArtisans();

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _ctrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<ArtisanModel> get _results {
    var list = _all.where((a) {
      final q = _query.toLowerCase();
      final matchQ = q.isEmpty ||
          a.name.toLowerCase().contains(q) ||
          a.specialty.toLowerCase().contains(q);
      return matchQ && (!_verifiedOnly || a.isVerified) && a.rating >= _minRating;
    }).toList();

    switch (_sort) {
      case _Sort.relevance:
        break;
      case _Sort.ratingDesc:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _Sort.priceAsc:
        list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final results = _results;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom8),
            child: Row(children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    size: 20, color: textColor),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    autofocus: widget.initialQuery == null,
                    textInputAction: TextInputAction.search,
                    style: AppTextStyles.bodyMediumRegular(color: textColor),
                    onChanged: (v) => setState(() => _query = v),
                    cursorColor: primary,
                    decoration: InputDecoration(
                      hintText: 'Search artisans or services…',
                      hintStyle: AppTextStyles.bodySmallRegular(
                          color: textColor.withValues(alpha: 0.4)),
                      prefixIcon:
                          Icon(Icons.search, color: primary, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded,
                                  size: 18,
                                  color: textColor.withValues(alpha: 0.5)),
                              onPressed: () => setState(() {
                                _ctrl.clear();
                                _query = '';
                              }),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              AppGaps.w8,
            ]),
          ),
        ),
        body: Column(children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.custom16,
                vertical: AppSpacing.custom8),
            child: Row(children: [
              _Chip(
                label: 'Relevance',
                selected: _sort == _Sort.relevance,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.relevance),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Top Rated',
                selected: _sort == _Sort.ratingDesc,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.ratingDesc),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Price ↑',
                selected: _sort == _Sort.priceAsc,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.priceAsc),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Verified',
                icon: Icons.verified_rounded,
                selected: _verifiedOnly,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Rating 4.5+',
                icon: Icons.star_rounded,
                selected: _minRating >= 4.5,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () =>
                    setState(() => _minRating = _minRating >= 4.5 ? 0 : 4.5),
              ),
            ]),
          ),

          // Results count
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
                AppSpacing.custom16, AppSpacing.custom8),
            child: Row(children: [
              Text('${results.length} result${results.length == 1 ? '' : 's'}',
                  style: AppTextStyles.bodyMediumSemibold(color: textColor)),
              if (_query.isNotEmpty) ...[
                Text(' for "',
                    style: AppTextStyles.bodyMediumRegular(
                        color: textColor.withValues(alpha: 0.55))),
                Text(_query,
                    style: AppTextStyles.bodyMediumSemibold(color: primary)),
                Text('"',
                    style: AppTextStyles.bodyMediumRegular(
                        color: textColor.withValues(alpha: 0.55))),
              ],
            ]),
          ),

          // Results list
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.search_off_rounded,
                          size: 56, color: primary.withValues(alpha: 0.3)),
                      AppGaps.h16,
                      Text('No artisans found',
                          style: AppTextStyles.bodyMediumRegular(
                              color: textColor.withValues(alpha: 0.5))),
                      if (_query.isNotEmpty) ...[
                        AppGaps.h4,
                        Text('Try a different search term',
                            style: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.35))),
                      ],
                    ]),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                        top: 4,
                        bottom: MediaQuery.of(context).padding.bottom + 72),
                    physics: const BouncingScrollPhysics(),
                    itemCount: results.length,
                    itemBuilder: (_, i) => ArtisanListTile(
                      artisan: results[i],
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      primary: primary,
                      onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.artisanProfile,
                          arguments: results[i]),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final Color primary, textColor, surfaceColor;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    this.icon,
    required this.selected,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (icon != null
                  ? primary.withValues(alpha: 0.12)
                  : primary)
              : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primary : textColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: selected ? primary : textColor.withValues(alpha: 0.5)),
            const SizedBox(width: 5),
          ],
          Text(label,
              style: AppTextStyles.bodySmallSemibold(
                  color: selected
                      ? (icon != null ? primary : Colors.white)
                      : textColor)),
        ]),
      ),
    );
  }
}
""".lstrip())

print("\nAll 7 files written successfully!")
