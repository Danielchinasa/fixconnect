import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SavedAddressesPage
// Lists saved addresses; allows adding and deleting via swipe or menu.
// ─────────────────────────────────────────────────────────────────────────────
class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  // Mock addresses
  final List<_Address> _addresses = [
    _Address(
      id: '1',
      label: 'Home',
      icon: Icons.home_rounded,
      street: '14 Admiralty Way',
      city: 'Lekki Phase 1',
      state: 'Lagos',
      isDefault: true,
    ),
    _Address(
      id: '2',
      label: 'Work',
      icon: Icons.business_center_rounded,
      street: '1A, Adeola Odeku Street',
      city: 'Victoria Island',
      state: 'Lagos',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    setState(() {
      for (final a in _addresses) {
        a.isDefault = a.id == id;
      }
    });
  }

  void _delete(String id) {
    setState(() => _addresses.removeWhere((a) => a.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Address removed',
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

  void _showAddSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subText = isDark ? AppColors.grey500 : AppColors.grey600;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;

    final labelCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

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
              'Add New Address',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 20),
            _AddressTextField(
              controller: labelCtrl,
              label: 'Label (e.g. Home, Office)',
              icon: Icons.label_outline_rounded,
              isDark: isDark,
              primary: primary,
              textColor: textColor,
              subText: subText,
              surfaceColor: surfaceColor,
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: streetCtrl,
              label: 'Street Address',
              icon: Icons.edit_road_outlined,
              isDark: isDark,
              primary: primary,
              textColor: textColor,
              subText: subText,
              surfaceColor: surfaceColor,
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: cityCtrl,
              label: 'City & State',
              icon: Icons.location_city_outlined,
              isDark: isDark,
              primary: primary,
              textColor: textColor,
              subText: subText,
              surfaceColor: surfaceColor,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (labelCtrl.text.trim().isEmpty ||
                      streetCtrl.text.trim().isEmpty)
                    return;
                  setState(() {
                    _addresses.add(
                      _Address(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        label: labelCtrl.text.trim(),
                        icon: Icons.location_on_rounded,
                        street: streetCtrl.text.trim(),
                        city: cityCtrl.text.trim(),
                        state: 'Nigeria',
                        isDefault: false,
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
                  'Save Address',
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
            'Saved Addresses',
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
            'Add Address',
            style: AppTextStyles.bodyMediumBold(
              color: isDark ? AppColors.grey900 : Colors.white,
            ),
          ),
        ),
        body: _addresses.isEmpty
            ? _EmptyState(
                icon: Icons.location_off_outlined,
                title: 'No Saved Addresses',
                subtitle: 'Add your home or work address for faster booking.',
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
                itemCount: _addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final addr = _addresses[i];
                  return _AddressCard(
                    address: addr,
                    isDark: isDark,
                    primary: primary,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    surfaceColor: surfaceColor,
                    onSetDefault: () => _setDefault(addr.id),
                    onDelete: () => _delete(addr.id),
                  );
                },
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Address Card
// ─────────────────────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final _Address address;
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subTextColor;
  final Color surfaceColor;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.isDark,
    required this.primary,
    required this.textColor,
    required this.subTextColor,
    required this.surfaceColor,
    required this.onSetDefault,
    required this.onDelete,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(address.icon, size: 20, color: primary),
          ),
          SizedBox(width: AppSpacing.custom12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: AppTextStyles.bodyMediumBold(color: textColor),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
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
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.street}, ${address.city}, ${address.state}',
                  style: AppTextStyles.bodySmallRegular(color: subTextColor),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (!address.isDefault)
                      _TextAction(
                        label: 'Set as Default',
                        color: primary,
                        onTap: onSetDefault,
                      ),
                    if (!address.isDefault) const SizedBox(width: 16),
                    _TextAction(
                      label: 'Delete',
                      color: AppColors.error,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TextAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.bodySmallBold(color: color)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Address text field (used in the add sheet)
// ─────────────────────────────────────────────────────────────────────────────
class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subText;
  final Color surfaceColor;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.icon,
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
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final Color primary;
  final Color textColor;
  final Color subTextColor;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
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
                icon,
                size: 32,
                color: primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.bodyLargeBold(color: textColor)),
            const SizedBox(height: 8),
            Text(
              subtitle,
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
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _Address {
  final String id;
  final String label;
  final IconData icon;
  final String street;
  final String city;
  final String state;
  bool isDefault;

  _Address({
    required this.id,
    required this.label,
    required this.icon,
    required this.street,
    required this.city,
    required this.state,
    required this.isDefault,
  });
}
