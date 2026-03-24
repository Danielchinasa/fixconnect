import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WorkSample — data class
// ─────────────────────────────────────────────────────────────────────────────

class WorkSample {
  final List<Color> gradientColors;
  final IconData icon;
  final String label;

  const WorkSample({
    required this.gradientColors,
    required this.icon,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// workSamplesForSpecialty — returns samples matching the artisan's specialty
// ─────────────────────────────────────────────────────────────────────────────

List<WorkSample> workSamplesForSpecialty(String specialty) {
  final s = specialty.toLowerCase();

  if (s.contains('plumb')) {
    return const [
      WorkSample(
        gradientColors: [Color(0xFF0dd0f0), Color(0xFF0477a8)],
        icon: Icons.plumbing_rounded,
        label: 'Pipe Replacement',
      ),
      WorkSample(
        gradientColors: [Color(0xFF1a6980), Color(0xFF0dd0f0)],
        icon: Icons.water_drop_rounded,
        label: 'Burst Pipe Fix',
      ),
      WorkSample(
        gradientColors: [Color(0xFF00b4d8), Color(0xFF0077b6)],
        icon: Icons.shower_rounded,
        label: 'Shower Install',
      ),
      WorkSample(
        gradientColors: [Color(0xFF48cae4), Color(0xFF0096c7)],
        icon: Icons.bathtub_rounded,
        label: 'Bathroom Fitting',
      ),
      WorkSample(
        gradientColors: [Color(0xFF023e8a), Color(0xFF0077b6)],
        icon: Icons.local_fire_department_rounded,
        label: 'Water Heater',
      ),
      WorkSample(
        gradientColors: [Color(0xFF0077b6), Color(0xFF023e8a)],
        icon: Icons.construction_rounded,
        label: 'Drain Unblock',
      ),
    ];
  }

  if (s.contains('electric')) {
    return const [
      WorkSample(
        gradientColors: [Color(0xFFFFB800), Color(0xFFFF6B00)],
        icon: Icons.electrical_services_rounded,
        label: 'Panel Upgrade',
      ),
      WorkSample(
        gradientColors: [Color(0xFFFF9500), Color(0xFFFF5C00)],
        icon: Icons.power_rounded,
        label: 'Outlet Install',
      ),
      WorkSample(
        gradientColors: [Color(0xFFf7b731), Color(0xFFe67e22)],
        icon: Icons.air_rounded,
        label: 'Ceiling Fan',
      ),
      WorkSample(
        gradientColors: [Color(0xFFFFD166), Color(0xFFFFB800)],
        icon: Icons.toggle_on_rounded,
        label: 'Smart Switch',
      ),
      WorkSample(
        gradientColors: [Color(0xFFFF6B6B), Color(0xFFFF9500)],
        icon: Icons.warning_rounded,
        label: 'Emergency Wire',
      ),
      WorkSample(
        gradientColors: [Color(0xFFFFB800), Color(0xFFe67e22)],
        icon: Icons.security_rounded,
        label: 'Security Light',
      ),
    ];
  }

  if (s.contains('carp')) {
    return const [
      WorkSample(
        gradientColors: [Color(0xFFFF9500), Color(0xFF8B4513)],
        icon: Icons.weekend_rounded,
        label: 'Custom Wardrobe',
      ),
      WorkSample(
        gradientColors: [Color(0xFFD2691E), Color(0xFF8B4513)],
        icon: Icons.bed_rounded,
        label: 'Bed Frame',
      ),
      WorkSample(
        gradientColors: [Color(0xFFA0522D), Color(0xFF6B3A2A)],
        icon: Icons.kitchen_rounded,
        label: 'Kitchen Cabinet',
      ),
      WorkSample(
        gradientColors: [Color(0xFFCD853F), Color(0xFF8B4513)],
        icon: Icons.desktop_windows_rounded,
        label: 'Office Desk',
      ),
      WorkSample(
        gradientColors: [Color(0xFFB8860B), Color(0xFF8B6914)],
        icon: Icons.door_back_door_rounded,
        label: 'Door Frame',
      ),
      WorkSample(
        gradientColors: [Color(0xFF8B4513), Color(0xFF5C2E00)],
        icon: Icons.shelves,
        label: 'Wall Shelving',
      ),
    ];
  }

  if (s.contains('clean')) {
    return const [
      WorkSample(
        gradientColors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        icon: Icons.cleaning_services_rounded,
        label: 'Deep Clean',
      ),
      WorkSample(
        gradientColors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
        icon: Icons.kitchen_rounded,
        label: 'Kitchen Scrub',
      ),
      WorkSample(
        gradientColors: [Color(0xFF86EFAC), Color(0xFF4ADE80)],
        icon: Icons.window_rounded,
        label: 'Window Clean',
      ),
      WorkSample(
        gradientColors: [Color(0xFF15803D), Color(0xFF166534)],
        icon: Icons.celebration_rounded,
        label: 'After Party',
      ),
      WorkSample(
        gradientColors: [Color(0xFF0dd0f0), Color(0xFF22C55E)],
        icon: Icons.home_rounded,
        label: 'Move-in Ready',
      ),
      WorkSample(
        gradientColors: [Color(0xFF16A34A), Color(0xFF15803D)],
        icon: Icons.business_rounded,
        label: 'Office Clean',
      ),
    ];
  }

  // Default (e.g., Painter)
  return const [
    WorkSample(
      gradientColors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
      icon: Icons.format_paint_rounded,
      label: 'Living Room',
    ),
    WorkSample(
      gradientColors: [Color(0xFFEC4899), Color(0xFFBE185D)],
      icon: Icons.house_rounded,
      label: 'Exterior Wall',
    ),
    WorkSample(
      gradientColors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
      icon: Icons.auto_awesome_rounded,
      label: 'Accent Wall',
    ),
    WorkSample(
      gradientColors: [Color(0xFFDB2777), Color(0xFF9D174D)],
      icon: Icons.cabin_rounded,
      label: 'Ceiling Paint',
    ),
    WorkSample(
      gradientColors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
      icon: Icons.business_center_rounded,
      label: 'Office Space',
    ),
    WorkSample(
      gradientColors: [Color(0xFF6D28D9), Color(0xFF4C1D95)],
      icon: Icons.fence_rounded,
      label: 'Gate & Fence',
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileWorkSampleCard
// ─────────────────────────────────────────────────────────────────────────────

class ProfileWorkSampleCard extends StatelessWidget {
  final WorkSample sample;

  const ProfileWorkSampleCard({super.key, required this.sample});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: sample.gradientColors,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(sample.icon, color: Colors.white, size: 28),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              sample.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
