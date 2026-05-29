import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/my_artisan_profile_cubit.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/services_cubit.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/edit_artisan_profile_sheet.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/manage_artisan_categories_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyArtisanProfilePage extends StatelessWidget {
  const MyArtisanProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MyArtisanProfileCubit>()..load()),
        BlocProvider(create: (_) => sl<ServicesCubit>()..load()),
      ],
      child: const _MyArtisanProfileView(),
    );
  }
}

class _MyArtisanProfileView extends StatefulWidget {
  const _MyArtisanProfileView();

  @override
  State<_MyArtisanProfileView> createState() => _MyArtisanProfileViewState();
}

class _MyArtisanProfileViewState extends State<_MyArtisanProfileView> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.bgColor;
    final textColor = context.textColor;
    final primary = context.primary;
    final surfaceColor = context.surfaceColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        body: BlocConsumer<MyArtisanProfileCubit, MyArtisanProfileState>(
          listener: (context, state) {
            if (state is MyArtisanProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profile updated successfully',
                    style: AppTextStyles.bodyMediumMedium(color: Colors.black),
                  ),
                  backgroundColor: primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            } else if (state is MyArtisanProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            final isUpdating = state is MyArtisanProfileUpdating;

            final artisan = switch (state) {
              MyArtisanProfileLoaded(:final artisan) => artisan,
              MyArtisanProfileUpdating(:final artisan) => artisan,
              MyArtisanProfileUpdateSuccess(:final artisan) => artisan,
              MyArtisanProfileUpdateError(:final artisan) => artisan,
              _ => null,
            };

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── App bar ────────────────────────────────────────────────
                SliverAppBar(
                  pinned: true,
                  backgroundColor: bgColor,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textColor,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    'Artisan Profile',
                    style: AppTextStyles.bodyLargeBold(color: textColor),
                  ),
                  actions: [
                    if (artisan != null && !isUpdating)
                      TextButton.icon(
                        onPressed: () => _openEditSheet(context, artisan),
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: primary,
                        ),
                        label: Text(
                          'Edit',
                          style: AppTextStyles.bodyMediumSemibold(
                            color: primary,
                          ),
                        ),
                      ),
                    if (isUpdating)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primary,
                          ),
                        ),
                      ),
                  ],
                ),

                // ── States ─────────────────────────────────────────────────
                if (state is MyArtisanProfileLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is MyArtisanProfileError)
                  SliverFillRemaining(
                    child: _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<MyArtisanProfileCubit>().load(),
                      textColor: textColor,
                      primary: primary,
                    ),
                  )
                else if (artisan != null) ...[
                  // ── Hero header ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _HeroSection(
                      artisan: artisan,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),

                  // ── Stats row ────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _StatsRow(
                      artisan: artisan,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),

                  // ── Info cards ───────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _InfoCards(
                      artisan: artisan,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),

                  // ── Bio ──────────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _SectionCard(
                      title: 'About Me',
                      icon: Icons.person_outline_rounded,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                      child: Text(
                        artisan.bio.isNotEmpty
                            ? artisan.bio
                            : 'No bio added yet. Tap Edit to add one.',
                        style: AppTextStyles.bodyMediumRegular(
                          color: artisan.bio.isNotEmpty
                              ? textColor
                              : textColor.withOpacity(0.45),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),

                  // ── Categories ───────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _CategoriesCard(
                      artisan: artisan,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                      onManage: () => _openCategorySheet(context, artisan),
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),

                  // ── Weekly schedule ──────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _ScheduleCard(
                      artisan: artisan,
                      primary: primary,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 32,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _openEditSheet(BuildContext context, ArtisanModel artisan) {
    final cubit = context.read<MyArtisanProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: EditArtisanProfileSheet(artisan: artisan),
      ),
    );
  }

  void _openCategorySheet(BuildContext context, ArtisanModel artisan) {
    final cubit = context.read<MyArtisanProfileCubit>();
    final servicesCubit = context.read<ServicesCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),
          BlocProvider.value(value: servicesCubit),
        ],
        child: ManageArtisanCategoriesSheet(artisan: artisan),
      ),
    );
  }
}

// ── Hero section ──────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final ArtisanModel artisan;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;

  const _HeroSection({
    required this.artisan,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: artisan.badgeColor.withOpacity(0.12),
              border: Border.all(
                color: artisan.badgeColor.withOpacity(0.35),
                width: 2.5,
              ),
            ),
            child: ClipOval(
              child: artisan.avatarUrl != null
                  ? Image.network(
                      artisan.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          artisan.initials,
                          style: AppTextStyles.header4Bold(
                            color: artisan.badgeColor,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        artisan.initials,
                        style: AppTextStyles.header4Bold(
                          color: artisan.badgeColor,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + verified
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        artisan.name,
                        style: AppTextStyles.bodyLargeBold(color: textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (artisan.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF22C55E),
                          size: 18,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Specialty
                Text(
                  artisan.specialty.isNotEmpty
                      ? artisan.specialty
                      : 'No specialty set',
                  style: AppTextStyles.bodyMediumRegular(
                    color: textColor.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 10),
                // Online / featured badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: artisan.isOnline
                            ? const Color(0xFF22C55E).withOpacity(0.12)
                            : Colors.grey.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: artisan.isOnline
                                  ? const Color(0xFF22C55E)
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            artisan.isOnline ? 'Online' : 'Offline',
                            style: AppTextStyles.bodySmallMedium(
                              color: artisan.isOnline
                                  ? const Color(0xFF22C55E)
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (artisan.isFeatured) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Color(0xFFFFB800),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Featured',
                              style: AppTextStyles.bodySmallMedium(
                                color: const Color(0xFFFFB800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final ArtisanModel artisan;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const _StatsRow({
    required this.artisan,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatCell(
              icon: Icons.handyman_rounded,
              iconColor: primary,
              value: artisan.completedJobs > 0
                  ? '${artisan.completedJobs}'
                  : '0',
              label: 'Jobs Done',
              textColor: textColor,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: textColor.withOpacity(0.10),
            ),
            _StatCell(
              icon: Icons.chat_bubble_rounded,
              iconColor: primary,
              value: '${artisan.reviews}',
              label: 'Reviews',
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final Color textColor;

  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMediumBold(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: AppTextStyles.bodySmallRegular(
              color: textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info cards ────────────────────────────────────────────────────────────────
class _InfoCards extends StatelessWidget {
  final ArtisanModel artisan;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;

  const _InfoCards({
    required this.artisan,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _InfoTile(
              icon: Icons.location_on_rounded,
              iconColor: primary,
              label: 'Location',
              value: artisan.location.isNotEmpty ? artisan.location : 'Not set',
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _InfoTile(
              icon: Icons.attach_money_rounded,
              iconColor: primary,
              label: 'Starting Price',
              value: artisan.startingPrice.isNotEmpty
                  ? artisan.startingPrice
                  : 'Not set',
              surfaceColor: surfaceColor,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color surfaceColor;
  final Color textColor;

  const _InfoTile({
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmallRegular(
                    color: textColor.withOpacity(0.50),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMediumSemibold(color: textColor),
                  maxLines: 1,
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

// ── Reusable section card ─────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final Widget child;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    required this.child,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primary, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.bodyMediumBold(color: textColor),
              ),
              const Spacer(),
              if (onAction != null && actionLabel != null)
                GestureDetector(
                  onTap: onAction,
                  child: Text(
                    actionLabel!,
                    style: AppTextStyles.bodyMediumSemibold(color: primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Categories card ───────────────────────────────────────────────────────────
class _CategoriesCard extends StatelessWidget {
  final ArtisanModel artisan;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;
  final VoidCallback onManage;

  const _CategoriesCard({
    required this.artisan,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Services Offered',
      icon: Icons.build_circle_outlined,
      primary: primary,
      textColor: textColor,
      surfaceColor: surfaceColor,
      isDark: isDark,
      actionLabel: 'Manage',
      onAction: onManage,
      child: artisan.categories.isEmpty
          ? Text(
              'No services added. Tap Manage to add your services.',
              style: AppTextStyles.bodyMediumRegular(
                color: textColor.withOpacity(0.45),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: artisan.categories
                  .map(
                    (c) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withOpacity(0.25)),
                      ),
                      child: Text(
                        c.name,
                        style: AppTextStyles.bodyMediumMedium(color: primary),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// ── Weekly schedule card ──────────────────────────────────────────────────────
class _ScheduleCard extends StatelessWidget {
  final ArtisanModel artisan;
  final Color primary;
  final Color textColor;
  final Color surfaceColor;
  final bool isDark;

  const _ScheduleCard({
    required this.artisan,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.isDark,
  });

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final schedule = artisan.weeklySchedule;
    if (schedule.isEmpty) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Weekly Schedule',
      icon: Icons.calendar_month_rounded,
      primary: primary,
      textColor: textColor,
      surfaceColor: surfaceColor,
      isDark: isDark,
      child: Column(
        children: _days.map((day) {
          final hours = schedule[day];
          final isOpen = hours != null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    day,
                    style: AppTextStyles.bodyMediumRegular(
                      color: isOpen ? textColor : textColor.withOpacity(0.35),
                    ),
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isOpen
                        ? const Color(0xFF22C55E)
                        : textColor.withOpacity(0.20),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isOpen ? hours : 'Closed',
                  style: AppTextStyles.bodyMediumRegular(
                    color: isOpen ? textColor : textColor.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Color textColor;
  final Color primary;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMediumRegular(
                color: textColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyles.bodySmallSemibold(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
