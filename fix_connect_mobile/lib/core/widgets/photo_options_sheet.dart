import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum PhotoOptionResult { camera, gallery, remove }

Future<PhotoOptionResult?> showPhotoOptionsSheet(
  BuildContext context, {
  required bool isDark,
  required Color primary,
  String title = 'Change Photo',
  bool showRemove = true,
}) {
  final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
  final textColor = isDark ? AppColors.darkText : AppColors.lightText;

  return showModalBottomSheet<PhotoOptionResult>(
    context: context,
    backgroundColor: surfBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Text(title, style: AppTextStyles.header4Bold(color: textColor)),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => Navigator.pop(context, PhotoOptionResult.camera),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.5)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.camera_alt_outlined, size: 20, color: primary),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Take a Photo',
                      style: AppTextStyles.bodyMediumMedium(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => Navigator.pop(context, PhotoOptionResult.gallery),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.5)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.photo_library_outlined, size: 20, color: primary),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Choose from Gallery',
                      style: AppTextStyles.bodyMediumMedium(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showRemove) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => Navigator.pop(context, PhotoOptionResult.remove),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.5)
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Remove Photo',
                        style: AppTextStyles.bodyMediumMedium(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
