import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final Widget asset;
  final VoidCallback onTap;
  const SocialIconButton({super.key, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.custom12),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      onTap: onTap,
      child: Container(
        width: AppSpacing.custom52,
        height: AppSpacing.custom52,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(AppSpacing.custom12),
        ),
        alignment: Alignment.center,
        child: asset,
      ),
    );
  }
}
