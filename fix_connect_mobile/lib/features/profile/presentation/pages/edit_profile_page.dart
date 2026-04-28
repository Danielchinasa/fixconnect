import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_style_extension.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/app/theme/app_theme_extension.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fix_connect_mobile/core/widgets/photo_options_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EditProfilePage
// Lets the user update their avatar, name, email, phone and bio.
// Uses a local mock state — wire to a bloc/repo when the backend is ready.
// ─────────────────────────────────────────────────────────────────────────────
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _bioFocus = FocusNode();

  bool _hasChanges = false;
  bool _isSaving = false;

  // Initial mock values — replace with real user model later
  static const _initName = 'Daniel Ochinasa';
  static const _initEmail = 'daniel@fixconnect.app';
  static const _initPhone = '+234 810 000 0000';
  static const _initBio =
      'Homeowner and DIY enthusiast. I love finding reliable artisans to help maintain my home.';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _initName);
    _emailCtrl = TextEditingController(text: _initEmail);
    _phoneCtrl = TextEditingController(text: _initPhone);
    _bioCtrl = TextEditingController(text: _initBio);

    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _bioCtrl]) {
      c.addListener(_markChanged);
    }
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _bioCtrl]) {
      c.dispose();
    }
    for (final f in [_nameFocus, _emailFocus, _phoneFocus, _bioFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  // ─── Actions ────────────────────────────────────────────────────────────────
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMediumMedium(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }
    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    // Reset both flags in ONE setState so the widget rebuilds with
    // canPop = true BEFORE Navigator.pop is attempted.
    setState(() {
      _isSaving = false;
      _hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully',
          style: AppTextStyles.bodyMediumMedium(color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
    // Defer the pop to the next frame so PopScope has already rebuilt
    // with canPop: true, otherwise onPopInvokedWithResult fires with
    // didPop = false and incorrectly shows the discard dialog.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    return await _showDiscardDialog() ?? false;
  }

  Future<bool?> _showDiscardDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfBg = isDark ? AppColors.surfaceDark : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subText = isDark ? AppColors.grey500 : AppColors.grey600;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: surfBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BottomSheetHandle(isDark: isDark),
            const SizedBox(height: 24),
            Text(
              'Discard Changes?',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'You have unsaved changes. Are you sure you want to leave?',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular(color: subText),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: 'Keep Editing',
                    onTap: () => Navigator.pop(ctx, false),
                    isDark: isDark,
                    textColor: textColor,
                    filled: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetButton(
                    label: 'Discard',
                    onTap: () => Navigator.pop(ctx, true),
                    isDark: isDark,
                    textColor: Colors.white,
                    filled: true,
                    fillColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: PopScope(
        canPop: !_hasChanges,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final should = await _showDiscardDialog();
          if (should == true && context.mounted) Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: textColor,
              ),
              onPressed: () async {
                if (await _onWillPop()) Navigator.pop(context);
              },
            ),
            title: Text(
              'Edit Profile',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.custom16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Avatar ────────────────────────────────────────────────
                  _AvatarPicker(isDark: isDark, primary: primary),
                  AppGaps.h32,

                  // ── Basic Info ────────────────────────────────────────────
                  SectionHeader(
                    title: 'Basic Info',
                    textColor: textColor,
                    primary: primary,
                    padding: EdgeInsets.zero,
                  ),
                  InputPrimary(
                    controller: _nameCtrl,
                    focusNode: _nameFocus,
                    label: 'Full Name',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: primary,
                    ),
                  ),
                  InputPrimary(
                    controller: _emailCtrl,
                    focusNode: _emailFocus,
                    label: 'Email Address',
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: primary,
                    ),
                  ),
                  InputPrimary(
                    controller: _phoneCtrl,
                    focusNode: _phoneFocus,
                    label: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined, color: primary),
                  ),
                  AppGaps.h16,

                  // ── About ─────────────────────────────────────────────────
                  SectionHeader(
                    title: 'About',
                    textColor: textColor,
                    primary: primary,
                    padding: EdgeInsets.zero,
                  ),
                  AppGaps.h8,
                  _BioInput(controller: _bioCtrl, focusNode: _bioFocus),
                  AppGaps.h32,

                  // ── Save button ───────────────────────────────────────────
                  ButtonPrimary(
                    text: _isSaving ? 'Saving…' : 'Save Changes',
                    bgColor: primary,
                    enabled: _hasChanges && !_isSaving,
                    onTap: _save,
                  ),
                  AppGaps.h32,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Avatar Picker
// ─────────────────────────────────────────────────────────────────────────────
class _AvatarPicker extends StatefulWidget {
  final bool isDark;
  final Color primary;

  const _AvatarPicker({required this.isDark, required this.primary});

  @override
  State<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<_AvatarPicker> {
  Future<void> _showPhotoOptions() async {
    final result = await showPhotoOptionsSheet(
      context,
      isDark: widget.isDark,
      primary: widget.primary,
      title: 'Change Profile Photo',
      showRemove: true,
    );
    if (result == null) return;
    final picker = ImagePicker();
    if (result == PhotoOptionResult.camera) {
      final x = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (x != null) {
        // TODO: handle picked avatar image
      }
    } else if (result == PhotoOptionResult.gallery) {
      final x = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (x != null) {
        // TODO: handle picked avatar image
      }
    } else if (result == PhotoOptionResult.remove) {
      // TODO: handle remove
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.primary.withValues(alpha: 0.15),
              border: Border.all(
                color: widget.primary.withValues(alpha: 0.4),
                width: 2.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'DO',
              style: AppTextStyles.header4Bold(
                color: widget.primary,
              ).copyWith(fontSize: 26),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _showPhotoOptions,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.primary,
                  border: Border.all(
                    color: widget.isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 15,
                  color: widget.isDark
                      ? AppColors.grey900
                      : AppColors.lightBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _PhotoOption removed — replaced by reusable photo options sheet

// ─────────────────────────────────────────────────────────────────────────────
// Bio input — multiline field that mirrors InputPrimary's container style.
// InputPrimary is single-line only, so this widget clones its decoration for
// the 4-line bio field.
// ─────────────────────────────────────────────────────────────────────────────
class _BioInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _BioInput({required this.controller, required this.focusNode});

  @override
  State<_BioInput> createState() => _BioInputState();
}

class _BioInputState extends State<_BioInput> {
  late final VoidCallback _focusListener;

  @override
  void initState() {
    super.initState();
    _focusListener = () {
      if (mounted) setState(() {});
    };
    widget.focusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => widget.focusNode.requestFocus(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSpacing.custom8),
        decoration: BoxDecoration(
          color: isFocused
              ? Theme.of(
                  context,
                ).extension<AppThemeExtension>()?.surfaceSelected
              : Theme.of(context).extension<AppThemeExtension>()?.surface,
          borderRadius: BorderRadius.circular(AppSpacing.custom12),
          border: isFocused
              ? Border.all(color: primary, width: IntegerConstants.borderWidth1)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.custom20,
            vertical: AppSpacing.custom16,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLines: null,
            minLines: 4,
            maxLength: 200,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textAlignVertical: TextAlignVertical.top,
            style: Theme.of(
              context,
            ).extension<AppTextStyleExtension>()?.bodyLargeSemibold,
            cursorColor: primary,
            autocorrect: false,
            decoration: InputDecoration(
              filled: false,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              labelText: 'Bio',
              alignLabelWithHint: true,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared bottom sheet widgets
// ─────────────────────────────────────────────────────────────────────────────
class _BottomSheetHandle extends StatelessWidget {
  final bool isDark;
  const _BottomSheetHandle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey700 : AppColors.grey300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Color textColor;
  final bool filled;
  final Color? fillColor;

  const _SheetButton({
    required this.label,
    required this.onTap,
    required this.isDark,
    required this.textColor,
    required this.filled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: fillColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMediumMedium(color: textColor),
        ),
      );
    }
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isDark ? AppColors.grey700 : AppColors.grey300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMediumMedium(color: textColor),
      ),
    );
  }
}
