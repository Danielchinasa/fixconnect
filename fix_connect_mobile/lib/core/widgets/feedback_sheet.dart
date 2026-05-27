import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/sheet_handle.dart';
import 'package:flutter/material.dart';

/// Shows a single-button bottom sheet for success or error feedback.
///
/// Usage:
/// ```dart
/// await showFeedbackSheet(context, isSuccess: true, message: 'Address saved!');
/// ```
Future<void> showFeedbackSheet(
  BuildContext context, {
  required bool isSuccess,
  required String message,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.isDark
        ? AppColors.surfaceDark
        : AppColors.lightBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FeedbackSheetBody(isSuccess: isSuccess, message: message),
  );
}

class _FeedbackSheetBody extends StatelessWidget {
  final bool isSuccess;
  final String message;

  const _FeedbackSheetBody({required this.isSuccess, required this.message});

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.success : AppColors.error;
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
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess
                  ? Icons.check_circle_outline_rounded
                  : Icons.error_outline_rounded,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumMedium(color: context.textColor),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isSuccess ? 'Done' : 'Dismiss',
                style: AppTextStyles.bodyMediumBold(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
