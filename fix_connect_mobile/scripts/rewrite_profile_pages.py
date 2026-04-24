"""Rewrite payment_methods_page.dart and saved_addresses_page.dart using shared widgets."""
import os

BASE = '/Applications/MAMP/htdocs/fixconnect/fix_connect_mobile/lib'

def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    lines = content.count('\n')
    print(f'✓ {path.replace(BASE+"/", "")} ({lines} lines)')


# ── payment_methods_page.dart ─────────────────────────────────────────────────
write(f'{BASE}/features/profile/presentation/pages/payment_methods_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/confirm_sheet.dart';
import 'package:fix_connect_mobile/core/widgets/empty_state.dart';
import 'package:fix_connect_mobile/core/widgets/form_text_field.dart';
import 'package:fix_connect_mobile/features/profile/data/models/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final List<PaymentCard> _cards = [
    PaymentCard(id: '1', brand: CardBrand.visa, last4: '4242',
        expiry: '08/27', holderName: 'Daniel Ochinasa', isDefault: true),
    PaymentCard(id: '2', brand: CardBrand.mastercard, last4: '1234',
        expiry: '12/26', holderName: 'Daniel Ochinasa', isDefault: false),
  ];

  void _setDefault(String id) {
    setState(() {
      for (final c in _cards) c.isDefault = c.id == id;
    });
  }

  void _remove(String id) {
    setState(() => _cards.removeWhere((c) => c.id == id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Card removed',
          style: AppTextStyles.bodyMediumMedium(color: Colors.white)),
      backgroundColor: AppColors.grey700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _confirmRemove(PaymentCard card) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.credit_card_off_outlined,
      title: 'Remove Card?',
      message:
          'Are you sure you want to remove the \${card.brandName} card ending in \${card.last4}?',
      confirmLabel: 'Remove',
      confirmColor: AppColors.error,
    );
    if (confirmed == true) _remove(card.id);
  }

  void _showAddSheet() {
    final primary = context.primary;
    final isDark = context.isDark;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = context.textColor;

    final numberCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(
                    color: isDark ? AppColors.grey700 : AppColors.grey300,
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Add Payment Card',
                style: AppTextStyles.header4Bold(color: textColor)),
            const SizedBox(height: 20),
            FormTextField(controller: numberCtrl, label: 'Card Number',
                icon: Icons.credit_card_rounded,
                keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            FormTextField(controller: nameCtrl, label: 'Cardholder Name',
                icon: Icons.person_outline_rounded),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: FormTextField(controller: expiryCtrl,
                  label: 'MM / YY', icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: FormTextField(controller: cvvCtrl, label: 'CVV',
                  icon: Icons.lock_outline_rounded,
                  keyboardType: TextInputType.number, obscureText: true)),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final num = numberCtrl.text.replaceAll(' ', '');
                  if (num.length < 4) return;
                  setState(() {
                    _cards.add(PaymentCard(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      brand: num.startsWith('4')
                          ? CardBrand.visa : CardBrand.mastercard,
                      last4: num.length >= 4
                          ? num.substring(num.length - 4) : '0000',
                      expiry: expiryCtrl.text.trim(),
                      holderName: nameCtrl.text.trim(),
                      isDefault: _cards.isEmpty,
                    ));
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: Text('Add Card',
                    style: AppTextStyles.bodyMediumBold(
                        color: isDark ? AppColors.grey900 : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.primary;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;
    final surfaceColor = context.surfaceColor;
    final bgColor = context.bgColor;

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
          title: Text('Payment Methods',
              style: AppTextStyles.header4Bold(color: textColor)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddSheet,
          backgroundColor: primary,
          icon: Icon(Icons.add_rounded,
              color: isDark ? AppColors.grey900 : Colors.white),
          label: Text('Add Card',
              style: AppTextStyles.bodyMediumBold(
                  color: isDark ? AppColors.grey900 : Colors.white)),
        ),
        body: _cards.isEmpty
            ? const EmptyState(
                icon: Icons.credit_card_off_outlined,
                title: 'No Payment Methods',
                subtitle: 'Add a card to pay for bookings quickly and securely.')
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(AppSpacing.custom16,
                    AppSpacing.custom16, AppSpacing.custom16, 120),
                itemCount: _cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final card = _cards[i];
                  return _CardTile(
                    card: card,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    primary: primary,
                    isDark: isDark,
                    onSetDefault: () => _setDefault(card.id),
                    onRemove: () => _confirmRemove(card),
                  );
                },
              ),
      ),
    );
  }
}

// ── Card tile ─────────────────────────────────────────────────────────────────
class _CardTile extends StatelessWidget {
  final PaymentCard card;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final Color primary;
  final bool isDark;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  const _CardTile({
    required this.card, required this.surfaceColor, required this.textColor,
    required this.subTextColor, required this.primary, required this.isDark,
    required this.onSetDefault, required this.onRemove,
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
      child: Column(children: [
        // Brand header
        Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            gradient: LinearGradient(
              colors: card.brand == CardBrand.visa
                  ? [const Color(0xFF1A1F71).withValues(alpha: 0.9),
                     const Color(0xFF0D47A1).withValues(alpha: 0.75)]
                  : [const Color(0xFFEB5757).withValues(alpha: 0.85),
                     const Color(0xFFEB9C13).withValues(alpha: 0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(card.brandName.toUpperCase(),
                style: AppTextStyles.bodyLargeBold(color: Colors.white)
                    .copyWith(letterSpacing: 2)),
            const Spacer(),
            Text('•••• \${card.last4}',
                style: AppTextStyles.bodyLargeSemibold(color: Colors.white)),
          ]),
        ),
        // Details
        Padding(
          padding: EdgeInsets.all(AppSpacing.custom16),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(card.holderName,
                  style: AppTextStyles.bodyMediumMedium(color: textColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('Expires \${card.expiry}',
                  style: AppTextStyles.bodySmallRegular(color: subTextColor)),
            ])),
            if (card.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Default',
                    style: AppTextStyles.bodySmallBold(color: primary)),
              ),
          ]),
        ),
        // Actions
        Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
              AppSpacing.custom16, AppSpacing.custom16),
          child: Row(children: [
            if (!card.isDefault) ...[
              _ActionChip(label: 'Set as Default', color: primary,
                  onTap: onSetDefault),
              const SizedBox(width: 10),
            ],
            _ActionChip(label: 'Remove', color: AppColors.error,
                onTap: onRemove),
          ]),
        ),
      ]),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: AppTextStyles.bodySmallBold(color: color)),
      ),
    );
  }
}
""".lstrip())


# ── saved_addresses_page.dart ─────────────────────────────────────────────────
write(f'{BASE}/features/profile/presentation/pages/saved_addresses_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/empty_state.dart';
import 'package:fix_connect_mobile/core/widgets/form_text_field.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  final List<SavedAddress> _addresses = [
    SavedAddress(id: '1', label: 'Home', icon: Icons.home_rounded,
        street: '14 Admiralty Way', city: 'Lekki Phase 1',
        state: 'Lagos', isDefault: true),
    SavedAddress(id: '2', label: 'Work', icon: Icons.business_center_rounded,
        street: '1A, Adeola Odeku Street', city: 'Victoria Island',
        state: 'Lagos', isDefault: false),
  ];

  void _setDefault(String id) {
    setState(() {
      for (final a in _addresses) a.isDefault = a.id == id;
    });
  }

  void _delete(String id) {
    setState(() => _addresses.removeWhere((a) => a.id == id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Address removed',
          style: AppTextStyles.bodyMediumMedium(color: Colors.white)),
      backgroundColor: AppColors.grey700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showAddSheet() {
    final isDark = context.isDark;
    final primary = context.primary;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = context.textColor;

    final labelCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(
                    color: isDark ? AppColors.grey700 : AppColors.grey300,
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Add New Address',
                style: AppTextStyles.header4Bold(color: textColor)),
            const SizedBox(height: 20),
            FormTextField(controller: labelCtrl,
                label: 'Label (e.g. Home, Office)',
                icon: Icons.label_outline_rounded),
            const SizedBox(height: 12),
            FormTextField(controller: streetCtrl, label: 'Street Address',
                icon: Icons.edit_road_outlined),
            const SizedBox(height: 12),
            FormTextField(controller: cityCtrl, label: 'City & State',
                icon: Icons.location_city_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (labelCtrl.text.trim().isEmpty ||
                      streetCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _addresses.add(SavedAddress(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labelCtrl.text.trim(),
                      icon: Icons.location_on_rounded,
                      street: streetCtrl.text.trim(),
                      city: cityCtrl.text.trim(),
                      state: 'Nigeria',
                      isDefault: false,
                    ));
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: Text('Save Address',
                    style: AppTextStyles.bodyMediumBold(
                        color: isDark ? AppColors.grey900 : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.primary;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;
    final surfaceColor = context.surfaceColor;
    final bgColor = context.bgColor;

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
          title: Text('Saved Addresses',
              style: AppTextStyles.header4Bold(color: textColor)),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddSheet,
          backgroundColor: primary,
          icon: Icon(Icons.add_rounded,
              color: isDark ? AppColors.grey900 : Colors.white),
          label: Text('Add Address',
              style: AppTextStyles.bodyMediumBold(
                  color: isDark ? AppColors.grey900 : Colors.white)),
        ),
        body: _addresses.isEmpty
            ? const EmptyState(
                icon: Icons.location_off_outlined,
                title: 'No Saved Addresses',
                subtitle: 'Add your home or work address for faster booking.')
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(AppSpacing.custom16,
                    AppSpacing.custom16, AppSpacing.custom16, 120),
                itemCount: _addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final addr = _addresses[i];
                  return _AddressCard(
                    address: addr,
                    surfaceColor: surfaceColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    primary: primary,
                    onSetDefault: () => _setDefault(addr.id),
                    onDelete: () => _delete(addr.id),
                  );
                },
              ),
      ),
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final SavedAddress address;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final Color primary;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address, required this.surfaceColor, required this.textColor,
    required this.subTextColor, required this.primary,
    required this.onSetDefault, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.custom16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom16),
        border: address.isDefault
            ? Border.all(color: primary.withValues(alpha: 0.45), width: 1.5)
            : null,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(address.icon, size: 20, color: primary)),
        SizedBox(width: AppSpacing.custom12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(address.label,
                  style: AppTextStyles.bodyMediumBold(color: textColor)),
              if (address.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('Default',
                      style: AppTextStyles.bodySmallBold(color: primary)),
                ),
              ],
            ]),
            const SizedBox(height: 4),
            Text('\${address.street}, \${address.city}, \${address.state}',
                style: AppTextStyles.bodySmallRegular(color: subTextColor)),
            const SizedBox(height: 12),
            Row(children: [
              if (!address.isDefault) ...[
                _TextAction(label: 'Set as Default', color: primary,
                    onTap: onSetDefault),
                const SizedBox(width: 16),
              ],
              _TextAction(label: 'Delete', color: AppColors.error,
                  onTap: onDelete),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TextAction({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.bodySmallBold(color: color)),
    );
  }
}
""".lstrip())

print("\nBoth pages rewritten!")
