import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PaymentMethodsPage
// Lists saved cards; supports setting a default and removing a card.
// ─────────────────────────────────────────────────────────────────────────────
class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final List<_PaymentCard> _cards = [
    _PaymentCard(
      id: '1',
      brand: _CardBrand.visa,
      last4: '4242',
      expiry: '08/27',
      holderName: 'Daniel Ochinasa',
      isDefault: true,
    ),
    _PaymentCard(
      id: '2',
      brand: _CardBrand.mastercard,
      last4: '1234',
      expiry: '12/26',
      holderName: 'Daniel Ochinasa',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    setState(() {
      for (final c in _cards) {
        c.isDefault = c.id == id;
      }
    });
  }

  void _remove(String id) {
    setState(() => _cards.removeWhere((c) => c.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Card removed',
          style: AppTextStyles.bodyMediumMedium(color: Colors.white),
        ),
        backgroundColor: AppColors.grey700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmRemove(BuildContext context, _PaymentCard card) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subText = isDark ? AppColors.grey500 : AppColors.grey600;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey700 : AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_off_outlined,
                size: 26,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Remove Card?',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to remove the ${card.brandName} card ending in ${card.last4}?',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular(color: subText),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark ? AppColors.grey700 : AppColors.grey300,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyMediumMedium(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _remove(card.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Remove',
                      style: AppTextStyles.bodyMediumMedium(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subText = isDark ? AppColors.grey500 : AppColors.grey600;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;

    final numberCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey700 : AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Payment Card',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 20),
            _CardTextField(
              controller: numberCtrl,
              label: 'Card Number',
              icon: Icons.credit_card_rounded,
              keyboardType: TextInputType.number,
              isDark: isDark,
              primary: primary,
              textColor: textColor,
              subText: subText,
              surfaceColor: surfaceColor,
            ),
            const SizedBox(height: 12),
            _CardTextField(
              controller: nameCtrl,
              label: 'Cardholder Name',
              icon: Icons.person_outline_rounded,
              isDark: isDark,
              primary: primary,
              textColor: textColor,
              subText: subText,
              surfaceColor: surfaceColor,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CardTextField(
                    controller: expiryCtrl,
                    label: 'MM / YY',
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                    isDark: isDark,
                    primary: primary,
                    textColor: textColor,
                    subText: subText,
                    surfaceColor: surfaceColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardTextField(
                    controller: cvvCtrl,
                    label: 'CVV',
                    icon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    isDark: isDark,
                    primary: primary,
                    textColor: textColor,
                    subText: subText,
                    surfaceColor: surfaceColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final num = numberCtrl.text.replaceAll(' ', '');
                  if (num.length < 4) return;
                  setState(() {
                    _cards.add(
                      _PaymentCard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        brand: num.startsWith('4')
                            ? _CardBrand.visa
                            : _CardBrand.mastercard,
                        last4: num.length >= 4
                            ? num.substring(num.length - 4)
                            : '0000',
                        expiry: expiryCtrl.text.trim(),
                        holderName: nameCtrl.text.trim(),
                        isDefault: _cards.isEmpty,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Add Card',
                  style: AppTextStyles.bodyMediumBold(
                    color: isDark ? AppColors.grey900 : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.grey500 : AppColors.grey600;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

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
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Payment Methods',
            style: AppTextStyles.header4Bold(color: textColor),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddSheet,
          backgroundColor: primary,
          icon: Icon(
            Icons.add_rounded,
            color: isDark ? AppColors.grey900 : Colors.white,
          ),
          label: Text(
            'Add Card',
            style: AppTextStyles.bodyMediumBold(
              color: isDark ? AppColors.grey900 : Colors.white,
            ),
          ),
        ),
        body: _cards.isEmpty
            ? _EmptyPaymentState(
                isDark: isDark,
                primary: primary,
                textColor: textColor,
                subTextColor: subTextColor,
              )
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  AppSpacing.custom16,
                  120,
                ),
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final card = _cards[i];
                  return _CardTile(
                    card: card,
                    isDark: isDark,
                    primary: primary,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    surfaceColor: surfaceColor,
                    onSetDefault: () => _setDefault(card.id),
                    onRemove: () => _confirmRemove(context, card),
                  );
                },
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Tile — shows brand gradient header + details
// ─────────────────────────────────────────────────────────────────────────────
class _CardTile extends StatelessWidget {
  final _PaymentCard card;
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subTextColor;
  final Color surfaceColor;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  const _CardTile({
    required this.card,
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.subTextColor,
    required this.surfaceColor,
    required this.onSetDefault,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom16),
        border: card.isDefault
            ? Border.all(color: primary.withValues(alpha: 0.45), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // ── Card visual strip ─────────────────────────────────────────────
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              gradient: LinearGradient(
                colors: card.brand == _CardBrand.visa
                    ? [
                        const Color(0xFF1A1F71).withValues(alpha: 0.9),
                        const Color(0xFF0D47A1).withValues(alpha: 0.75),
                      ]
                    : [
                        const Color(0xFFEB5757).withValues(alpha: 0.85),
                        const Color(0xFFEB9C13).withValues(alpha: 0.75),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  card.brandName.toUpperCase(),
                  style: AppTextStyles.bodyLargeBold(
                    color: Colors.white,
                  ).copyWith(letterSpacing: 2),
                ),
                const Spacer(),
                Text(
                  '•••• ${card.last4}',
                  style: AppTextStyles.bodyLargeSemibold(color: Colors.white),
                ),
              ],
            ),
          ),

          // ── Card details ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(AppSpacing.custom16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.holderName,
                        style: AppTextStyles.bodyMediumMedium(color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Expires ${card.expiry}',
                        style: AppTextStyles.bodySmallRegular(
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (card.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Default',
                      style: AppTextStyles.bodySmallBold(color: primary),
                    ),
                  ),
              ],
            ),
          ),

          // ── Actions ───────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.custom16,
              0,
              AppSpacing.custom16,
              AppSpacing.custom16,
            ),
            child: Row(
              children: [
                if (!card.isDefault)
                  _ActionChip(
                    label: 'Set as Default',
                    color: primary,
                    onTap: onSetDefault,
                    isDark: isDark,
                  ),
                if (!card.isDefault) const SizedBox(width: 10),
                _ActionChip(
                  label: 'Remove',
                  color: AppColors.error,
                  onTap: onRemove,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionChip({
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: AppTextStyles.bodySmallBold(color: color)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card text field
// ─────────────────────────────────────────────────────────────────────────────
class _CardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subText;
  final Color surfaceColor;

  const _CardTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.subText,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTextStyles.bodyMediumMedium(color: textColor),
      cursorColor: primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmallMedium(color: subText),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(icon, size: 20, color: subText),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.grey700 : AppColors.grey200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyPaymentState extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subTextColor;

  const _EmptyPaymentState({
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_off_outlined,
                size: 32,
                color: primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Payment Methods',
              style: AppTextStyles.bodyLargeBold(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a card to pay for bookings quickly and securely.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular(color: subTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────
enum _CardBrand { visa, mastercard }

class _PaymentCard {
  final String id;
  final _CardBrand brand;
  final String last4;
  final String expiry;
  final String holderName;
  bool isDefault;

  String get brandName => brand == _CardBrand.visa ? 'Visa' : 'Mastercard';

  _PaymentCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.holderName,
    required this.isDefault,
  });
}
