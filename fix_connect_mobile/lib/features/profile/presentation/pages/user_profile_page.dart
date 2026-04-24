import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/section_header.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_identity_card.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_menu_section.dart';
import 'package:fix_connect_mobile/features/profile/presentation/widgets/profile_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _notificationsEnabled = true;

  void _push(String route) => Navigator.of(context).pushNamed(route);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.bgColor;
    final textColor = context.textColor;
    final primary = context.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
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
                    subtitle: '+234 810 000 0000',
                    onTap: () => _push(AppRoutes.personalInformation),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'Saved Addresses',
                    subtitle: '2 addresses',
                    onTap: () => _push(AppRoutes.savedAddresses),
                  ),
                  ProfileMenuItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment Methods',
                    subtitle: 'Visa •••• 4242',
                    onTap: () => _push(AppRoutes.paymentMethods),
                  ),
                  ProfileMenuToggle(
                    icon: Icons.notifications_outlined,
                    label: 'Push Notifications',
                    value: _notificationsEnabled,
                    onChanged: (v) => setState(() => _notificationsEnabled = v),
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
                  ProfileMenuItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'My Bookings',
                    subtitle: '12 total',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.bookmark_outline_rounded,
                    label: 'Saved Artisans',
                    subtitle: '5 saved',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.star_outline_rounded,
                    label: 'My Reviews',
                    subtitle: '7 reviews given',
                    onTap: () {},
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
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
                child: const ProfileLogoutButton(),
              ),
            ),
            SliverToBoxAdapter(child: AppGaps.h32),
          ],
        ),
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
