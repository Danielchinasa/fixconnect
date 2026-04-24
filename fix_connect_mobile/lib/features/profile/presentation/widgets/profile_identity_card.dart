import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';

/// The avatar + name/email/badge identity card at the top of UserProfilePage.
class ProfileIdentityCard extends StatelessWidget {
  final VoidCallback onEditTap;

  // Replace with real user model when backend is ready.
  static const _userName = 'Daniel Ochinasa';
  static const _userEmail = 'daniel@fixconnect.app';
  static const _memberSince = 'Member since Jan 2025';
  static const _avatarInitials = 'DO';

  const ProfileIdentityCard({super.key, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;
    final surfaceColor = context.surfaceColor;
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.custom20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
        ),
        child: Row(
          children: [
            // Avatar with camera edit badge
            Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.35),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _avatarInitials,
                    style: AppTextStyles.bodyLargeBold(color: primary),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onEditTap,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 12,
                        color: isDark
                            ? AppColors.grey900
                            : AppColors.lightBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSpacing.custom16),

            // Name / email / since
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: AppTextStyles.bodyLargeBold(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppGaps.h4,
                  Text(
                    _userEmail,
                    style: AppTextStyles.bodyMediumRegular(color: subTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppGaps.h4,
                  Row(
                    children: [
                      Icon(Icons.verified_rounded, size: 13, color: primary),
                      const SizedBox(width: 4),
                      Text(
                        _memberSince,
                        style: AppTextStyles.bodySmallRegular(
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit button
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.1),
                ),
                child: Icon(Icons.edit_outlined, size: 18, color: primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
