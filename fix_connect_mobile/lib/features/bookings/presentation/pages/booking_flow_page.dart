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
            'Your booking with ${widget.artisan.name} has been sent.\nYou will receive a confirmation shortly.',
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
