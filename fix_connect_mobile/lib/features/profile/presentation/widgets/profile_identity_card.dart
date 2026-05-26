import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The avatar + name/email/badge identity card at the top of UserProfilePage.
class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({super.key, required this.onEditTap, this.user});

  final VoidCallback onEditTap;
  final UserEntity? user;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _memberSince(DateTime? date) {
    if (date == null) return '';
    return 'Member since ${DateFormat('MMM yyyy').format(date)}';
  }

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
                    _initials(user?.name ?? ''),
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
                    user?.name ?? '—',
                    style: AppTextStyles.bodyLargeBold(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppGaps.h4,
                  Text(
                    user?.email ?? '—',
                    style: AppTextStyles.bodyMediumRegular(color: subTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppGaps.h4,
                  Row(
                    children: [
                      Icon(
                        user?.isVerified == true
                            ? Icons.verified_rounded
                            : Icons.pending_outlined,
                        size: 13,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user?.createdAt != null
                            ? _memberSince(user?.createdAt)
                            : (user?.isVerified == true
                                  ? 'Verified'
                                  : 'Unverified'),
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
