import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/my_artisan_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditArtisanProfileSheet extends StatefulWidget {
  final ArtisanModel artisan;

  const EditArtisanProfileSheet({super.key, required this.artisan});

  @override
  State<EditArtisanProfileSheet> createState() =>
      _EditArtisanProfileSheetState();
}

class _EditArtisanProfileSheetState extends State<EditArtisanProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bioCtrl;
  late final TextEditingController _specialtyCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _responseTimeCtrl;

  @override
  void initState() {
    super.initState();
    _bioCtrl = TextEditingController(text: widget.artisan.bio);
    _specialtyCtrl = TextEditingController(text: widget.artisan.specialty);
    // Starting price is stored as a formatted string like "₦5,000"; send raw
    // number to API — strip non-digits.
    final rawPrice = widget.artisan.startingPrice.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    _priceCtrl = TextEditingController(text: rawPrice);
    _locationCtrl = TextEditingController(text: widget.artisan.location);
    _responseTimeCtrl = TextEditingController(
      text: widget.artisan.responseTime,
    );
  }

  @override
  void dispose() {
    for (final c in [
      _bioCtrl,
      _specialtyCtrl,
      _priceCtrl,
      _locationCtrl,
      _responseTimeCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final price = int.tryParse(_priceCtrl.text.trim());
    context.read<MyArtisanProfileCubit>().updateProfile({
      if (_bioCtrl.text.trim().isNotEmpty) 'bio': _bioCtrl.text.trim(),
      if (_specialtyCtrl.text.trim().isNotEmpty)
        'specialty': _specialtyCtrl.text.trim(),
      if (price != null) 'startingPrice': price,
      if (_locationCtrl.text.trim().isNotEmpty)
        'location': _locationCtrl.text.trim(),
      if (_responseTimeCtrl.text.trim().isNotEmpty)
        'responseTime': _responseTimeCtrl.text.trim(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final primary = context.primary;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final surfaceColor = context.surfaceColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Handle + header
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              'Edit Artisan Profile',
                              style: AppTextStyles.header4Bold(
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Fields
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.list(
                    children: [
                      _Field(
                        label: 'Bio',
                        controller: _bioCtrl,
                        textColor: textColor,
                        surfaceColor: surfaceColor,
                        isDark: isDark,
                        maxLines: 4,
                        hint: 'Tell clients about yourself…',
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Specialty',
                        controller: _specialtyCtrl,
                        textColor: textColor,
                        surfaceColor: surfaceColor,
                        isDark: isDark,
                        hint: 'e.g. Electrician, Plumber…',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Starting Price (₦)',
                        controller: _priceCtrl,
                        textColor: textColor,
                        surfaceColor: surfaceColor,
                        isDark: isDark,
                        hint: 'e.g. 5000',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Location',
                        controller: _locationCtrl,
                        textColor: textColor,
                        surfaceColor: surfaceColor,
                        isDark: isDark,
                        hint: 'e.g. Lagos, Nigeria',
                      ),
                      const SizedBox(height: 16),
                      _Field(
                        label: 'Response Time',
                        controller: _responseTimeCtrl,
                        textColor: textColor,
                        surfaceColor: surfaceColor,
                        isDark: isDark,
                        hint: 'e.g. Within 1 hour',
                      ),
                      const SizedBox(height: 32),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Changes',
                            style: AppTextStyles.bodyLargeBold(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable form field ───────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.controller,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.black.withOpacity(0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmallSemibold(
            color: textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: AppTextStyles.bodyMediumRegular(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMediumRegular(
              color: textColor.withOpacity(0.35),
            ),
            filled: true,
            fillColor: surfaceColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
