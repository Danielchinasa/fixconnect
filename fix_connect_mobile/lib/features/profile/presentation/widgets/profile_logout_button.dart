import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/confirm_sheet.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The red "Log Out" row with a confirmation bottom sheet.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;

    return InkWell(
      onTap: () => _confirm(context),
      borderRadius: BorderRadius.circular(AppSpacing.custom16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.custom16,
          vertical: AppSpacing.custom16,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.error,
              ),
            ),
            SizedBox(width: AppSpacing.custom12),
            Expanded(
              child: Text(
                'Log Out',
                style: AppTextStyles.bodyMediumMedium(color: AppColors.error),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showConfirmSheet(
      context,
      icon: Icons.logout_rounded,
      title: 'Log Out?',
      message: 'You will need to sign in again to access your account.',
      confirmLabel: 'Log Out',
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().logOut();
    }
  }
}
