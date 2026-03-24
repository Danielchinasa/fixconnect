import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/pages/bookings_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/home_tab.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:flutter/material.dart';

// 📚 CONCEPT: Navigation Shell Pattern
// The HomePage is now a "shell" — its ONLY job is managing which tab is active.
// All real content is delegated to the individual tab widgets.
//
// IndexedStack renders ALL children at once but only SHOWS the one at `index`.
// Why not PageView? PageView destroys/rebuilds pages when you swipe away.
// IndexedStack keeps them all alive → scroll position preserved when switching tabs.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  // 📚 CONCEPT: Declarative list of tab bodies.
  // Adding a new tab = add one entry here. Zero changes elsewhere in the shell.
  static const List<Widget> _tabs = [
    HomeTab(),
    _PlaceholderTab(label: 'Search', icon: Icons.search_rounded),
    BookingsPage(),
    _PlaceholderTab(label: 'Messages', icon: Icons.chat_bubble_rounded),
    _PlaceholderTab(label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 📚 CONCEPT: IndexedStack
      // Renders all _tabs widgets but clips visibility to only index _currentNavIndex.
      // Each child is kept alive in the widget tree — no rebuilds on tab switch.
      body: IndexedStack(index: _currentNavIndex, children: _tabs),
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
