import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

/// The sticky bottom bar with Book Now + Message buttons.
class ArtisanBookingBar extends StatelessWidget {
  final ArtisanModel artisan;

  const ArtisanBookingBar({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final surfaceColor = context.surfaceColor;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.custom16,
        AppSpacing.custom14,
        AppSpacing.custom16,
        MediaQuery.of(context).padding.bottom + AppSpacing.custom14,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonPrimary(
            text: 'Book Now',
            bgColor: primary,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.bookingFlow, arguments: artisan),
            trailing: Icon(
              Icons.calendar_month_rounded,
              color: Theme.of(context).colorScheme.surface,
              size: AppSpacing.custom18,
            ),
          ),
          AppGaps.h10,
          ButtonPrimary(
            text: 'Message',
            bgColor: surfaceColor,
            textColor: primary,
            onTap: () {},
            trailing: Icon(
              Icons.chat_bubble_outline_rounded,
              color: primary,
              size: AppSpacing.custom18,
            ),
          ),
        ],
      ),
    );
  }
}
