import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    super.key,
    required this.text,
    this.onTap,
    this.trailing,
    required this.bgColor,
    this.textColor,
    this.enabled = true,
  });

  final String text;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool enabled;
  final Color bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isInverse = bgColor != primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.custom24),
        boxShadow: isInverse
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: primary,
                  offset: Offset(AppSpacing.custom4, AppSpacing.custom8),
                  blurRadius: AppSpacing.custom24,
                  spreadRadius: -10,
                ),
              ],
      ),
      child: MaterialButton(
        height: AppSpacing.custom48,
        onPressed: enabled
            ? () {
                if (onTap != null) {
                  onTap!.call();
                }
              }
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.custom24),
        ),
        minWidth: MediaQuery.of(context).size.width,
        color: bgColor,
        disabledElevation: 0.02,
        disabledColor: AppColors.grey400,
        elevation: AppSpacing.custom0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTextWidget(context),
            if (trailing != null) _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWidget(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.header4Bold(
          color: textColor ?? Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.custom8, left: AppSpacing.custom16),
      child: trailing,
    );
  }
}
