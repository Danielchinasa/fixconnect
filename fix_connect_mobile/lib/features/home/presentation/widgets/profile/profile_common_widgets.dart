import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ProfileCircleIconButton
// ─────────────────────────────────────────────────────────────────────────────

class ProfileCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isCollapsed;
  final bool isDark;

  const ProfileCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.isCollapsed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isCollapsed
        ? (isDark ? AppColors.darkText : AppColors.lightText)
        : Theme.of(context).colorScheme.primary;
    final bgColor = isCollapsed
        ? Colors.transparent
        : Colors.black.withOpacity(0.22);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileStatCell
// ─────────────────────────────────────────────────────────────────────────────

class ProfileStatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color textColor;

  const ProfileStatCell({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.custom4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.custom26),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.header4Bold(color: textColor)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileInfoCard
// ─────────────────────────────────────────────────────────────────────────────

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color surfaceColor;
  final Color textColor;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.surfaceColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.custom14,
        vertical: AppSpacing.custom14,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppSpacing.custom16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.custom8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: AppSpacing.custom18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMediumRegular(
                    color: textColor.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMediumBold(color: textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfilePulseDot
// ─────────────────────────────────────────────────────────────────────────────

class ProfilePulseDot extends StatefulWidget {
  final Color color;
  final bool isActive;

  const ProfilePulseDot({
    super.key,
    required this.color,
    required this.isActive,
  });

  @override
  State<ProfilePulseDot> createState() => _ProfilePulseDotState();
}

class _ProfilePulseDotState extends State<ProfilePulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = Tween<double>(
      begin: 0.9,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (widget.isActive) _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      );
    }
    return ScaleTransition(
      scale: _anim,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileStarRow
// ─────────────────────────────────────────────────────────────────────────────

class ProfileStarRow extends StatelessWidget {
  final double rating;

  const ProfileStarRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        if (rating >= i + 1) {
          return const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFB800),
            size: 16,
          );
        } else if (rating >= i + 0.5) {
          return const Icon(
            Icons.star_half_rounded,
            color: Color(0xFFFFB800),
            size: 16,
          );
        }
        return const Icon(
          Icons.star_outline_rounded,
          color: Color(0xFFFFB800),
          size: 16,
        );
      }),
    );
  }
}
