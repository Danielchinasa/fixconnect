import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/confirm_sheet.dart';
import 'package:fix_connect_mobile/core/widgets/empty_state.dart';
import 'package:fix_connect_mobile/core/widgets/feedback_sheet.dart';
import 'package:fix_connect_mobile/core/widgets/form_text_field.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().load();
  }

  IconData _iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('home')) return Icons.home_rounded;
    if (l.contains('work') || l.contains('office')) {
      return Icons.business_center_rounded;
    }
    if (l.contains('school')) return Icons.school_rounded;
    return Icons.location_on_rounded;
  }

  Future<void> _confirmSetDefault(SavedAddress addr) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.location_on_outlined,
      title: 'Set as Default?',
      message: 'Use "${addr.label}" as your default address for bookings?',
      confirmLabel: 'Set as Default',
      confirmColor: context.primary,
    );
    if (confirmed == true && mounted) {
      context.read<AddressCubit>().setDefault(addr.id);
    }
  }

  Future<void> _confirmDelete(SavedAddress addr) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.delete_outline_rounded,
      title: 'Delete Address?',
      message:
          'This will permanently remove "${addr.label}" from your saved addresses.',
      confirmLabel: 'Delete',
    );
    if (confirmed == true && mounted) {
      context.read<AddressCubit>().delete(addr.id);
    }
  }

  void _showAddressSheet({SavedAddress? editing}) {
    final isDark = context.isDark;
    final primary = context.primary;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = context.textColor;

    final labelCtrl = TextEditingController(text: editing?.label ?? '');
    final addressCtrl = TextEditingController(text: editing?.address ?? '');
    final cityCtrl = TextEditingController(text: editing?.city ?? '');
    final stateCtrl = TextEditingController(text: editing?.state ?? '');

    final isEdit = editing != null;

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
              isEdit ? 'Edit Address' : 'Add New Address',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 20),
            FormTextField(
              controller: labelCtrl,
              label: 'Label (e.g. Home, Office)',
              icon: Icons.label_outline_rounded,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: addressCtrl,
              label: 'Street Address',
              icon: Icons.edit_road_outlined,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: cityCtrl,
              label: 'City',
              icon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 12),
            FormTextField(
              controller: stateCtrl,
              label: 'State',
              icon: Icons.map_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (labelCtrl.text.trim().isEmpty ||
                      addressCtrl.text.trim().isEmpty)
                    return;
                  Navigator.pop(ctx);
                  if (isEdit) {
                    context.read<AddressCubit>().update(
                      editing.id,
                      label: labelCtrl.text.trim(),
                      address: addressCtrl.text.trim(),
                      city: cityCtrl.text.trim(),
                      province: stateCtrl.text.trim(),
                    );
                  } else {
                    context.read<AddressCubit>().create(
                      label: labelCtrl.text.trim(),
                      address: addressCtrl.text.trim(),
                      city: cityCtrl.text.trim(),
                      province: stateCtrl.text.trim(),
                    );
                  }
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
                  isEdit ? 'Save Changes' : 'Save Address',
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
    final isDark = context.isDark;
    final primary = context.primary;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;
    final surfaceColor = context.surfaceColor;
    final bgColor = context.bgColor;

    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressError) {
          showFeedbackSheet(context, isSuccess: false, message: state.message);
        }
        if (state is AddressLoaded && state.successMessage != null) {
          showFeedbackSheet(
            context,
            isSuccess: true,
            message: state.successMessage!,
          );
        }
      },
      builder: (context, state) {
        final addresses = switch (state) {
          AddressLoaded(:final addresses) => addresses,
          AddressError(:final addresses) => addresses,
          _ => const <SavedAddress>[],
        };
        final isLoading = state is AddressLoading;
        final isSubmitting = state is AddressLoaded && state.isSubmitting;
        final loadingId = state is AddressLoaded ? state.loadingId : null;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
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
              onPressed: isSubmitting ? null : () => _showAddressSheet(),
              backgroundColor: isSubmitting
                  ? primary.withValues(alpha: 0.6)
                  : primary,
              icon: isSubmitting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? AppColors.grey900 : Colors.white,
                      ),
                    )
                  : Icon(
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
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : addresses.isEmpty
                ? const EmptyState(
                    icon: Icons.location_off_outlined,
                    title: 'No Saved Addresses',
                    subtitle:
                        'Add your home or work address for faster booking.',
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.custom16,
                      AppSpacing.custom16,
                      AppSpacing.custom16,
                      120,
                    ),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final addr = addresses[i];
                      return _AddressCard(
                        address: addr,
                        icon: _iconForLabel(addr.label),
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        primary: primary,
                        isLoading: loadingId == addr.id,
                        onSetDefault: () => _confirmSetDefault(addr),
                        onDelete: () => _confirmDelete(addr),
                        onEdit: () => _showAddressSheet(editing: addr),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.icon,
    required this.surfaceColor,
    required this.textColor,
    required this.subTextColor,
    required this.primary,
    required this.isLoading,
    required this.onSetDefault,
    required this.onDelete,
    required this.onEdit,
  });

  final SavedAddress address;
  final IconData icon;
  final Color surfaceColor;
  final Color textColor;
  final Color subTextColor;
  final Color primary;
  final bool isLoading;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

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
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  )
                : Icon(icon, size: 20, color: primary),
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
                  '${address.address}, ${address.city}, ${address.state}',
                  style: AppTextStyles.bodySmallRegular(color: subTextColor),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (!address.isDefault) ...[
                      _TextAction(
                        label: 'Set as Default',
                        color: primary,
                        onTap: isLoading ? null : onSetDefault,
                      ),
                      const SizedBox(width: 16),
                    ],
                    _TextAction(
                      label: 'Edit',
                      color: subTextColor,
                      onTap: isLoading ? null : onEdit,
                    ),
                    const SizedBox(width: 16),
                    _TextAction(
                      label: 'Delete',
                      color: AppColors.error,
                      onTap: isLoading ? null : onDelete,
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
  const _TextAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.bodySmallBold(
          color: onTap == null ? color.withValues(alpha: 0.4) : color,
        ),
      ),
    );
  }
}
