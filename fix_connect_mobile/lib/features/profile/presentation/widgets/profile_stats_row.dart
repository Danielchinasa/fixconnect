import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/stats_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';

/// The three-stat row (Bookings / Reviews / Rating) on UserProfilePage.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;
    final isArtisan = user?.role == 'Artisan';

    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StatsLoaded) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
            child: Row(
              children: [
                _StatChip(
                  label: 'Bookings',
                  value: "${state.totalBookings}",
                  icon: Icons.calendar_today_rounded,
                  primary: primary,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                ),
                SizedBox(width: AppSpacing.custom12),
                _StatChip(
                  label: 'Reviews',
                  value: "${state.totalReviews}",
                  icon: Icons.chat_bubble_rounded,
                  primary: primary,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                ),
                if (isArtisan) ...[
                  SizedBox(width: AppSpacing.custom12),
                  _StatChip(
                    label: 'Completed Jobs',
                    value: "${state.completedJobs}",
                    icon: Icons.work_outline,
                    primary: primary,
                    textColor: textColor,
                    surfaceColor: surfaceColor,
                  ),
                ],
                SizedBox(width: AppSpacing.custom12),
                _StatChip(
                  label: 'Rating',
                  value: state.avgRating != null
                      ? "${state.avgRating!.toStringAsFixed(1)} ★"
                      : "N/A",
                  icon: Icons.star_rounded,
                  primary: primary,
                  textColor: textColor,
                  surfaceColor: surfaceColor,
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Failed to load stats'));
        }
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: primary),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.bodyMediumBold(color: textColor)),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmallRegular(color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }
}
