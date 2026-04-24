import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/sheet_handle.dart';
import 'package:flutter/material.dart';

/// Standard destructive-action confirmation bottom sheet.
///
/// Shows an icon, a title, a body message, a cancel button and a
/// destructive confirm button. Pops [true] on confirm, [false] on cancel.
///
/// Usage:
/// ```dart
/// final confirmed = await showConfirmSheet(
///   context,
///   icon: Icons.logout_rounded,
///   title: 'Log Out?',
///   message: 'You will need to sign in again.',
///   confirmLabel: 'Log Out',
/// );
/// if (confirmed == true) { ... }
/// ```
Future<bool?> showConfirmSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  Color? confirmColor,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: context.isDark
        ? AppColors.surfaceDark
        : AppColors.lightBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ConfirmSheetBody(
      icon: icon,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor ?? AppColors.error,
    ),
  );
}

class _ConfirmSheetBody extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;

  const _ConfirmSheetBody({
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          const SizedBox(height: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: confirmColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: confirmColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.header4Bold(color: context.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular(color: context.subTextColor),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: context.isDark
                          ? AppColors.grey700
                          : AppColors.grey300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyMediumMedium(
                      color: context.textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    confirmLabel,
                    style: AppTextStyles.bodyMediumMedium(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
