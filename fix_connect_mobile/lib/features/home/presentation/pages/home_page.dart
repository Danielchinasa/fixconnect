import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/pages/bookings_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/home_tab.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/services_all_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

// 📚 CONCEPT: Navigation Shell Pattern
// The HomePage is now a "shell" — its ONLY job is managing which tab is active.
// All real content is delegated to the individual tab widgets.
//
// IndexedStack renders ALL children at once but only SHOWS the one at `index`.
// Why not PageView? PageView destroys/rebuilds pages when you swipe away.
// IndexedStack keeps them all alive → scroll position preserved when switching tabs.
class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentNavIndex;

  void _switchToServicesTab() => setState(() => _currentNavIndex = 1);

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    _currentNavIndex = _currentNavIndex;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    // Built here (not static const) so the callback can be wired in.
    final tabs = [
      HomeTab(onSeeAllServices: _switchToServicesTab),
      const ServicesAllPage(),
      const BookingsPage(),
      const _PlaceholderTab(label: 'Messages', icon: Icons.chat_bubble_rounded),
      const UserProfilePage(),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _currentNavIndex, children: tabs),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        primary: primary,
        isDark: isDark,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Temporary placeholder shown for tabs not yet built.
// Replaced feature-by-feature with the real implementation.
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PlaceholderTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: primary.withValues(alpha: 0.25)),
            const SizedBox(height: 16),
            Text(
              '$label — Coming Soon',
              style: AppTextStyles.bodyLargeSemibold(
                color: textColor.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
