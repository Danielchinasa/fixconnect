import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/core/widgets/network_svg_icon.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/services_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/artisan_setup/presentation/cubit/artisan_setup_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page shell — two-step wizard for artisan profile creation
// ─────────────────────────────────────────────────────────────────────────────

class ArtisanSetupPage extends StatefulWidget {
  const ArtisanSetupPage({super.key, required this.user});

  final UserEntity? user;

  @override
  State<ArtisanSetupPage> createState() => _ArtisanSetupPageState();
}

class _ArtisanSetupPageState extends State<ArtisanSetupPage> {
  final _pageController = PageController();
  int _step = 0;
  String? _selectedCategoryId;

  void _goToStep(int step) {
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skip(BuildContext ctx) {
    ctx.read<AuthCubit>().logIn(widget.user);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ArtisanSetupCubit>()),
        BlocProvider(create: (_) => sl<ServicesCubit>()..load()),
      ],
      child: Builder(
        builder: (ctx) {
          final isDark = ctx.isDark;
          final textColor = ctx.textColor;
          final primary = ctx.primary;
          final bgColor = ctx.bgColor;

          return BlocListener<ArtisanSetupCubit, ArtisanSetupState>(
            listener: (ctx, state) {
              if (state is ArtisanSetupProfileCreated) {
                _goToStep(1);
              } else if (state is ArtisanSetupComplete) {
                ctx.read<AuthCubit>().logIn(widget.user);
              } else if (state is ArtisanSetupError) {
                ScaffoldMessenger.of(ctx)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(ctx).colorScheme.error,
                    ),
                  );
              }
            },
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark,
              ),
              child: Scaffold(
                backgroundColor: bgColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      _WizardHeader(
                        step: _step,
                        totalSteps: 2,
                        onBack: _step > 0 ? () => _goToStep(_step - 1) : null,
                        primary: primary,
                        textColor: textColor,
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _ProfileStep(
                              textColor: textColor,
                              primary: primary,
                              isDark: isDark,
                              bgColor: bgColor,
                              surfaceColor: ctx.surfaceColor,
                              onSkip: () => _skip(ctx),
                            ),
                            _CategoriesStep(
                              textColor: textColor,
                              primary: primary,
                              isDark: isDark,
                              surfaceColor: ctx.surfaceColor,
                              selectedId: _selectedCategoryId,
                              onSelected: (id) {
                                setState(() => _selectedCategoryId = id);
                              },
                              onSubmit: () {
                                if (_selectedCategoryId == null) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please select a service category',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                ctx.read<ArtisanSetupCubit>().setCategories([
                                  _selectedCategoryId!,
                                ]);
                              },
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
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress header
// ─────────────────────────────────────────────────────────────────────────────

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.step,
    required this.totalSteps,
    this.onBack,
    required this.primary,
    required this.textColor,
  });

  final int step;
  final int totalSteps;
  final VoidCallback? onBack;
  final Color primary;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: onBack != null
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                    ),
                    color: textColor,
                    onPressed: onBack,
                  )
                : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (i) {
                final active = i <= step;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == step ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? primary : primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '${step + 1}/$totalSteps',
              style: AppTextStyles.bodySmallMedium(
                color: textColor.withValues(alpha: 0.45),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Profile form
// ─────────────────────────────────────────────────────────────────────────────

const _responseTimes = [
  'Within 1 hour',
  'Within 2 hours',
  'Same day',
  'Within 24 hours',
  'Within 2 days',
];

const _days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class _ProfileStep extends StatefulWidget {
  const _ProfileStep({
    required this.textColor,
    required this.primary,
    required this.isDark,
    required this.bgColor,
    required this.surfaceColor,
    required this.onSkip,
  });

  final Color textColor;
  final Color primary;
  final bool isDark;
  final Color bgColor;
  final Color surfaceColor;
  final VoidCallback onSkip;

  @override
  State<_ProfileStep> createState() => _ProfileStepState();
}

class _ProfileStepState extends State<_ProfileStep> {
  final _formKey = GlobalKey<FormState>();
  final _specialtyCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _responseTime = 'Within 2 hours';

  final Map<String, bool> _dayEnabled = {
    for (final d in _days) d: !['Saturday', 'Sunday'].contains(d),
  };
  final Map<String, TextEditingController> _dayTimeCtrl = {
    for (final d in _days) d: TextEditingController(text: '9am - 5pm'),
  };

  @override
  void dispose() {
    _specialtyCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    _priceCtrl.dispose();
    for (final c in _dayTimeCtrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final schedule = {
      for (final d in _days)
        d: _dayEnabled[d]! ? _dayTimeCtrl[d]!.text.trim() : null,
    };
    final price = int.tryParse(_priceCtrl.text.replaceAll(',', '')) ?? 0;
    context.read<ArtisanSetupCubit>().createProfile(
      specialty: _specialtyCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      startingPrice: price,
      responseTime: _responseTime,
      weeklySchedule: schedule,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtisanSetupCubit, ArtisanSetupState>(
      builder: (context, state) {
        final isLoading = state is ArtisanSetupLoading;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppGaps.h8,
                Text(
                  'Set up your artisan profile',
                  style: AppTextStyles.h3Heading.copyWith(
                    color: widget.textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppGaps.h4,
                Text(
                  'Tell clients about your skills and experience.',
                  style: AppTextStyles.bodyMediumRegular(
                    color: widget.textColor.withValues(alpha: 0.55),
                  ),
                ),
                AppGaps.h16,

                // Warning card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFB800).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFB07C00),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Without completing your artisan profile, you won't appear in search results or be visible to clients.",
                          style: AppTextStyles.bodySmallRegular(
                            color: const Color(0xFF7A5500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppGaps.h24,

                // Specialty
                _FieldLabel('Specialty *', widget.textColor),
                const SizedBox(height: 6),
                _InputField(
                  controller: _specialtyCtrl,
                  hint: 'e.g. Plumber, Electrician, Carpenter',
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                AppGaps.h16,

                // Bio
                _FieldLabel('Bio *', widget.textColor),
                const SizedBox(height: 6),
                _InputField(
                  controller: _bioCtrl,
                  hint: 'Describe your experience and what makes you great...',
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 20) {
                      return 'Please write at least 20 characters';
                    }
                    return null;
                  },
                ),
                AppGaps.h16,

                // Location
                _FieldLabel('Location *', widget.textColor),
                const SizedBox(height: 6),
                _InputField(
                  controller: _locationCtrl,
                  hint: 'e.g. Lagos, Ikeja',
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                AppGaps.h16,

                // Starting price
                _FieldLabel('Starting price *', widget.textColor),
                const SizedBox(height: 6),
                _InputField(
                  controller: _priceCtrl,
                  hint: '5000',
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  keyboardType: TextInputType.number,
                  prefixText: '₦ ',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Enter a valid price';
                    return null;
                  },
                ),
                AppGaps.h16,

                // Response time
                _FieldLabel('Typical response time *', widget.textColor),
                const SizedBox(height: 6),
                _DropdownField(
                  value: _responseTime,
                  items: _responseTimes,
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  onChanged: (v) => setState(() => _responseTime = v!),
                ),
                AppGaps.h24,

                // Weekly availability
                Text(
                  'Weekly availability',
                  style: AppTextStyles.bodyLargeBold(color: widget.textColor),
                ),
                AppGaps.h4,
                Text(
                  "Set the days and hours you're typically available.",
                  style: AppTextStyles.bodySmallRegular(
                    color: widget.textColor.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 12),
                _WeeklyScheduleCard(
                  days: _days,
                  dayEnabled: _dayEnabled,
                  dayTimeCtrl: _dayTimeCtrl,
                  textColor: widget.textColor,
                  surfaceColor: widget.surfaceColor,
                  primary: widget.primary,
                  isDark: widget.isDark,
                  onToggle: (day, val) =>
                      setState(() => _dayEnabled[day] = val),
                ),
                AppGaps.h32,

                ButtonPrimary(
                  text: 'Continue',
                  bgColor: widget.primary,
                  trailing: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                  isLoading: isLoading,
                  enabled: !isLoading,
                  onTap: _submit,
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: widget.onSkip,
                    child: Text(
                      'Skip for now',
                      style: AppTextStyles.bodySmallMedium(
                        color: widget.textColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                AppGaps.h32,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — Category selection
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesStep extends StatelessWidget {
  const _CategoriesStep({
    required this.textColor,
    required this.primary,
    required this.isDark,
    required this.surfaceColor,
    required this.selectedId,
    required this.onSelected,
    required this.onSubmit,
  });

  final Color textColor;
  final Color primary;
  final bool isDark;
  final Color surfaceColor;
  final String? selectedId;
  final void Function(String id) onSelected;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesCubitState>(
      builder: (context, catState) {
        final categories = catState is ServicesLoaded
            ? catState.categories
            : <ServiceCategoryModel>[];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGaps.h8,
              Text(
                'What services do you offer?',
                style: AppTextStyles.h3Heading.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppGaps.h4,
              Text(
                'Choose one to get started, you can change this later.',
                style: AppTextStyles.bodyMediumRegular(
                  color: textColor.withValues(alpha: 0.55),
                ),
              ),
              AppGaps.h24,
              if (catState is ServicesLoading || catState is ServicesInitial)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categories.map((cat) {
                    final selected = cat.id == selectedId;
                    return _CategoryChip(
                      category: cat,
                      selected: selected,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                      onTap: () => onSelected(cat.id),
                    );
                  }).toList(),
                ),
              AppGaps.h32,
              BlocBuilder<ArtisanSetupCubit, ArtisanSetupState>(
                builder: (context, state) {
                  return ButtonPrimary(
                    text: 'Finish Setup',
                    bgColor: primary,
                    trailing: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                    isLoading: state is ArtisanSetupLoading,
                    enabled: state is! ArtisanSetupLoading,
                    onTap: onSubmit,
                  );
                },
              ),
              AppGaps.h32,
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    required this.onTap,
  });

  final ServiceCategoryModel category;
  final bool selected;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.12) : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? primary
                : isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.check_rounded, size: 14, color: primary),
              ),
            SizedBox(
              width: 18,
              height: 18,
              child: category.iconSvg != null && category.iconSvg!.isNotEmpty
                  ? SvgPicture.string(
                      category.iconSvg!,
                      colorFilter: ColorFilter.mode(
                        selected ? primary : textColor.withValues(alpha: 0.6),
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      NetworkSvgIcon.iconForCategory(category.name),
                      size: 16,
                      color: selected
                          ? primary
                          : textColor.withValues(alpha: 0.6),
                    ),
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: AppTextStyles.bodySmallMedium(
                color: selected ? primary : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weekly schedule card
// ─────────────────────────────────────────────────────────────────────────────

class _WeeklyScheduleCard extends StatelessWidget {
  const _WeeklyScheduleCard({
    required this.days,
    required this.dayEnabled,
    required this.dayTimeCtrl,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
    required this.onToggle,
  });

  final List<String> days;
  final Map<String, bool> dayEnabled;
  final Map<String, TextEditingController> dayTimeCtrl;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;
  final bool isDark;
  final void Function(String day, bool val) onToggle;

  @override
  Widget build(BuildContext context) {
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: days.asMap().entries.map((entry) {
          final i = entry.key;
          final day = entry.value;
          final enabled = dayEnabled[day]!;
          final isLast = i == days.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 38,
                      child: Text(
                        day.substring(0, 3),
                        style: AppTextStyles.bodyMediumMedium(color: textColor),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      alignment: Alignment.centerLeft,
                      child: Switch.adaptive(
                        value: enabled,
                        onChanged: (v) => onToggle(day, v),
                        activeColor: primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (enabled) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: TextField(
                            controller: dayTimeCtrl[day],
                            style: AppTextStyles.bodySmallRegular(
                              color: textColor,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: primary.withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.12)
                                      : Colors.black.withValues(alpha: 0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primary),
                              ),
                              hintText: '9am - 5pm',
                              hintStyle: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          'Not available',
                          style: AppTextStyles.bodySmallRegular(
                            color: textColor.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: 14,
                  endIndent: 14,
                  color: dividerColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared form helpers
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, this.textColor);

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySmallMedium(
        color: textColor.withValues(alpha: 0.7),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixText,
    this.prefixIcon,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;
  final bool isDark;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? prefixText;
  final IconData? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: AppTextStyles.bodyMediumRegular(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMediumRegular(
          color: textColor.withValues(alpha: 0.35),
        ),
        prefixText: prefixText,
        prefixStyle: AppTextStyles.bodyMediumRegular(color: textColor),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 18,
                color: textColor.withValues(alpha: 0.5),
              )
            : null,
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
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
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.textColor,
    required this.surfaceColor,
    required this.primary,
    required this.isDark,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final Color textColor;
  final Color surfaceColor;
  final Color primary;
  final bool isDark;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          borderRadius: BorderRadius.circular(12),
          style: AppTextStyles.bodyMediumRegular(color: textColor),
          dropdownColor: surfaceColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textColor.withValues(alpha: 0.5),
          ),
          items: items
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
