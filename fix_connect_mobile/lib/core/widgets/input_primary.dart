import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_style_extension.dart';
import 'package:fix_connect_mobile/app/theme/app_theme_extension.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:flutter/material.dart';

class InputPrimary extends StatefulWidget {
  const InputPrimary({
    super.key,
    this.label,
    required this.focusNode,
    required this.controller,
    this.onSubmit,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.autofocus,
  });

  final String? label;
  final ValueChanged<String>? onSubmit;
  final FocusNode focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? autofocus;
  final TextEditingController controller;

  @override
  State<InputPrimary> createState() => _InputPrimaryState();
}

class _InputPrimaryState extends State<InputPrimary> {
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.focusNode.requestFocus();
      },
      child: Container(
        height: AppSpacing.custom60,
        margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isFocused
              ? Theme.of(
                  context,
                ).extension<AppThemeExtension>()?.surfaceSelected
              : Theme.of(context).extension<AppThemeExtension>()?.surface,
          borderRadius: BorderRadius.circular(AppSpacing.custom12),
          border: isFocused
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: IntegerConstants.borderWidth1,
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom20),
          child: Center(
            child: Row(
              children: [
                widget.prefixIcon ?? SizedBox(),
                SizedBox(
                  width: widget.prefixIcon != null
                      ? AppSpacing.custom12
                      : AppSpacing.zero,
                ),
                Expanded(
                  child: TextFormField(
                    obscureText: widget.obscureText ?? false,
                    controller: widget.controller,
                    autofocus: widget.autofocus ?? false,
                    focusNode: widget.focusNode,
                    maxLines: 1,
                    style: Theme.of(
                      context,
                    ).extension<AppTextStyleExtension>()?.bodyLargeSemibold,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    autocorrect: false,
                    decoration: InputDecoration(
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      labelText: widget.label,
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.suffixIcon != null
                      ? AppSpacing.custom12
                      : AppSpacing.zero,
                ),
                widget.suffixIcon ?? SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
