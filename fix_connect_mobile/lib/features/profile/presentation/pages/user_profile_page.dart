import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/section_header.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/address_cubit.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/reviews_cubit.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/stats_cubit.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/my_reviews_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/saved_addresses_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_menu_section.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _notificationsEnabled = true;

  void _push(String route) => Navigator.of(context).pushNamed(route);

  void _pushSavedAddresses() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AddressCubit>(),
          child: const SavedAddressesPage(),
        ),
      ),
    );
  }

  void _pushMyReviews() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ReviewsCubit>(),
          child: const MyReviewsPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StatsCubit>()..fetchStats(),
      child: Builder(
        builder: (context) {
          return _buildProfilePage(context);
        },
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.bgColor;
    final textColor = context.textColor;
    final primary = context.primary;

    // Keep AuthCubit in sync when ProfileCubit fetches fresh data.
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          context.read<AuthCubit>().logIn(state.user);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final user = authState is AuthAuthenticated ? authState.user : null;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: bgColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: bgColor,
                    surfaceTintColor: Colors.transparent,
                    title: Text(
                      'My Profile',
                      style: AppTextStyles.header4Bold(color: textColor),
                    ),
                    actions: [
                      _AppBarIcon(
                        icon: Icons.settings_outlined,
                        onTap: () => _push(AppRoutes.settings),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: ProfileIdentityCard(
                      user: user,
                      onEditTap: () => _push(AppRoutes.editProfile),
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h16),
                  const SliverToBoxAdapter(child: ProfileStatsRow()),
                  SliverToBoxAdapter(child: AppGaps.h24),

                  // ── Account ──────────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Account',
                      textColor: textColor,
                      primary: primary,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h8),
                  SliverToBoxAdapter(
                    child: ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Personal Information',
                          subtitle: user?.phone.isNotEmpty == true
                              ? user!.phone
                              : '',
                          onTap: () => _push(AppRoutes.personalInformation),
                        ),
                        BlocBuilder<AddressCubit, AddressState>(
                          builder: (context, addrState) {
                            final count = addrState is AddressLoaded
                                ? addrState.addresses.length
                                : 0;
                            final subtitle = count == 1
                                ? '1 address'
                                : '$count addresses';
                            return ProfileMenuItem(
                              icon: Icons.location_on_outlined,
                              label: 'Saved Addresses',
                              subtitle: subtitle,
                              onTap: _pushSavedAddresses,
                            );
                          },
                        ),
                        // TODO: Payment Methods — coming soon
                        ProfileMenuToggle(
                          icon: Icons.notifications_outlined,
                          label: 'Push Notifications',
                          value: _notificationsEnabled,
                          onChanged: (v) =>
                              setState(() => _notificationsEnabled = v),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h24),

                  // ── Activity ─────────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Activity',
                      textColor: textColor,
                      primary: primary,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h8),
                  SliverToBoxAdapter(
                    child: ProfileMenuSection(
                      items: [
                        // Removed 'My Bookings' and 'Saved Artisans' as requested
                        BlocBuilder<ReviewsCubit, ReviewsState>(
                          builder: (context, reviewsState) {
                            final count = reviewsState is ReviewsLoaded
                                ? reviewsState.reviews.length
                                : 0;
                            final subtitle = count == 1
                                ? '1 review'
                                : '$count reviews';
                            return ProfileMenuItem(
                              icon: Icons.star_outline_rounded,
                              label: 'My Reviews',
                              subtitle: subtitle,
                              onTap: _pushMyReviews,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h24),

                  // ── Support ──────────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Support',
                      textColor: textColor,
                      primary: primary,
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h8),
                  SliverToBoxAdapter(
                    child: ProfileMenuSection(
                      items: [
                        ProfileMenuItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & FAQ',
                          onTap: () => _push(AppRoutes.helpSupport),
                        ),
                        ProfileMenuItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Contact Support',
                          onTap: () => _push(AppRoutes.helpSupport),
                        ),
                        ProfileMenuItem(
                          icon: Icons.shield_outlined,
                          label: 'Terms & Privacy',
                          onTap: () => _push(AppRoutes.termsPrivacy),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h24),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.custom16,
                      ),
                      child: const ProfileLogoutButton(),
                    ),
                  ),
                  SliverToBoxAdapter(child: AppGaps.h32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── AppBar icon button ────────────────────────────────────────────────────────
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: context.primary),
      ),
    );
  }
}
