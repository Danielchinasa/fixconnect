import 'dart:io';
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
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fix_connect_mobile/core/widgets/photo_options_sheet.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EditProfilePage
// Lets the user update their avatar, name, email, phone and bio.
// Now wires to repository for PATCH and avatar upload.
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
  late final TextEditingController _cityCtrl;

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _bioFocus = FocusNode();
  final _cityFocus = FocusNode();

  String? _gender;
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _bioCtrl = TextEditingController(text: user?.bio ?? '');
    _cityCtrl = TextEditingController(text: user?.city ?? '');
    _gender = user?.gender;

    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _bioCtrl, _cityCtrl]) {
      c.addListener(_markChanged);
    }
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _bioCtrl, _cityCtrl]) {
      c.dispose();
    }
    for (final f in [
      _nameFocus,
      _emailFocus,
      _phoneFocus,
      _bioFocus,
      _cityFocus,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  // ─── Actions ────────────────────────────────────────────────────────────────
  Future<void> _uploadAvatar(String filePath) async {
    final repo = sl<ProfileRepository>();
    final result = await repo.uploadAvatar(filePath: filePath);
    if (!mounted) return;
    if (result is Err) {
      _showError((result as Err).failure.message);
      return;
    }
    // Refresh full profile so the new avatarUrl is reflected everywhere.
    final refreshed = await repo.getMe();
    if (!mounted) return;
    if (refreshed is Ok) {
      context.read<AuthCubit>().logIn((refreshed as Ok<UserEntity>).value);
      setState(() {});
    }
  }

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

    final nameParts = name.split(' ');
    final firstName = nameParts.first;
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    final bio = _bioCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    setState(() => _isSaving = true);
    final repo = sl<ProfileRepository>();
    final result = await repo.updateProfile(
      firstName: firstName,
      lastName: lastName.isNotEmpty ? lastName : null,
      bio: bio.isNotEmpty ? bio : null,
      city: city.isNotEmpty ? city : null,
      gender: _gender,
    );
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      if (result is Ok) _hasChanges = false;
    });
    if (result is Ok) {
      context.read<AuthCubit>().logIn((result as Ok<UserEntity>).value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully',
            style: AppTextStyles.bodyMediumMedium(color: Colors.white),
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    } else if (result is Err) {
      _showError((result as Err).failure.message);
    }
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
                  _AvatarPicker(
                    isDark: isDark,
                    primary: primary,
                    avatarUrl:
                        context.read<AuthCubit>().state is AuthAuthenticated
                        ? (context.read<AuthCubit>().state as AuthAuthenticated)
                              .user
                              ?.avatarUrl
                        : null,
                    initials: () {
                      final authState = context.read<AuthCubit>().state;
                      final name = authState is AuthAuthenticated
                          ? authState.user?.name.trim() ?? ''
                          : '';
                      if (name.isEmpty) return '?';
                      final parts = name.split(RegExp(r'\s+'));
                      if (parts.length == 1)
                        return parts.first[0].toUpperCase();
                      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
                    }(),
                  ),
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

                  // ── Location & Identity ───────────────────────────────────
                  SectionHeader(
                    title: 'Location & Identity',
                    textColor: textColor,
                    primary: primary,
                    padding: EdgeInsets.zero,
                  ),
                  InputPrimary(
                    controller: _cityCtrl,
                    focusNode: _cityFocus,
                    label: 'City',
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                      color: primary,
                    ),
                  ),
                  _GenderDropdown(
                    value: _gender,
                    primary: primary,
                    isDark: isDark,
                    onChanged: (v) {
                      setState(() {
                        _gender = v;
                        _hasChanges = true;
                      });
                    },
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
                  AppGaps.h16,

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
  final String? avatarUrl;
  final String initials;

  const _AvatarPicker({
    required this.isDark,
    required this.primary,
    this.avatarUrl,
    required this.initials,
  });

  @override
  State<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<_AvatarPicker> {
  bool _uploading = false;
  String? _localPath; // optimistic preview while upload is in progress

  static const _maxBytes = 5 * 1024 * 1024; // 5 MB
  static const _allowedExts = {'jpg', 'jpeg', 'png', 'webp'};

  void _showError(String message) {
    if (!context.mounted) return;
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handlePicked(String path) async {
    // Validate extension
    final ext = path.toLowerCase().split('.').last;
    if (!_allowedExts.contains(ext)) {
      _showError('Only JPEG, PNG or WebP images are supported');
      return;
    }
    // Validate size
    final bytes = await File(path).length();
    if (bytes > _maxBytes) {
      _showError('Image must be smaller than 5 MB');
      return;
    }

    setState(() {
      _uploading = true;
      _localPath = path;
    });

    await context
        .findAncestorStateOfType<_EditProfilePageState>()
        ?._uploadAvatar(path);

    if (mounted) setState(() => _uploading = false);
  }

  Future<void> _showPhotoOptions() async {
    final result = await showPhotoOptionsSheet(
      context,
      isDark: widget.isDark,
      primary: widget.primary,
      title: 'Change Profile Photo',
      showRemove: false,
    );
    if (result == null) return;
    final picker = ImagePicker();
    XFile? picked;
    if (result == PhotoOptionResult.camera) {
      picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
    } else if (result == PhotoOptionResult.gallery) {
      picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
    }
    if (picked != null && context.mounted) {
      await _handlePicked(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;
    if (_localPath != null) {
      // Optimistic preview: show the locally-picked file immediately
      avatarContent = ClipOval(
        child: Image.file(
          File(_localPath!),
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.avatarUrl != null) {
      avatarContent = ClipOval(
        child: Image.network(
          widget.avatarUrl!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Text(
            widget.initials,
            style: AppTextStyles.header4Bold(
              color: widget.primary,
            ).copyWith(fontSize: 26),
          ),
        ),
      );
    } else {
      avatarContent = Text(
        widget.initials,
        style: AppTextStyles.header4Bold(
          color: widget.primary,
        ).copyWith(fontSize: 26),
      );
    }

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
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
            child: avatarContent,
          ),
          // Loading overlay during upload
          if (_uploading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _uploading ? null : _showPhotoOptions,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _uploading ? AppColors.grey500 : widget.primary,
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
// ─────────────────────────────────────────────────────────────────────────────
// Gender Dropdown
// ─────────────────────────────────────────────────────────────────────────────
class _GenderDropdown extends StatelessWidget {
  final String? value;
  final Color primary;
  final bool isDark;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({
    required this.value,
    required this.primary,
    required this.isDark,
    required this.onChanged,
  });

  static const _options = ['male', 'female'];
  static const _labels = {'male': 'Male', 'female': 'Female'};

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.grey500 : AppColors.grey600;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSpacing.custom8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.grey700.withValues(alpha: 0.5)
              : AppColors.grey200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(Icons.wc_outlined, color: primary, size: 20),
              const SizedBox(width: 12),
              Text(
                'Gender',
                style: AppTextStyles.bodyMediumRegular(color: subTextColor),
              ),
            ],
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: subTextColor),
          dropdownColor: surfaceColor,
          isExpanded: true,
          style: AppTextStyles.bodyMediumRegular(color: textColor),
          items: _options.map((opt) {
            return DropdownMenuItem(
              value: opt,
              child: Row(
                children: [
                  Icon(Icons.wc_outlined, color: primary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _labels[opt] ?? opt,
                    style: AppTextStyles.bodyMediumRegular(color: textColor),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: primary,
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.custom12),
              Expanded(
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
                    alignLabelWithHint: true,
                    labelText: 'Bio',
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    hintText: 'Tell others about yourself...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    counterText: '',
                  ),
                ),
              ),
            ],
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
