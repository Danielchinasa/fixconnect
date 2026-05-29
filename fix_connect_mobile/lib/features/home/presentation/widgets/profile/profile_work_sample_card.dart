import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WorkSample — data class
// ─────────────────────────────────────────────────────────────────────────────

class WorkSample {
  final IconData icon;
  final String label;

  const WorkSample({required this.icon, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────
// workSamplesForSpecialty — returns samples matching the artisan's specialty
// ─────────────────────────────────────────────────────────────────────────────

List<WorkSample> workSamplesForSpecialty(String specialty) {
  final s = specialty.toLowerCase();

  if (s.contains('plumb')) {
    return const [
      WorkSample(icon: Icons.plumbing_rounded, label: 'Pipe Replacement'),
      WorkSample(icon: Icons.water_drop_rounded, label: 'Burst Pipe Fix'),
      WorkSample(icon: Icons.shower_rounded, label: 'Shower Install'),
      WorkSample(icon: Icons.bathtub_rounded, label: 'Bathroom Fitting'),
      WorkSample(
        icon: Icons.local_fire_department_rounded,
        label: 'Water Heater',
      ),
      WorkSample(icon: Icons.construction_rounded, label: 'Drain Unblock'),
    ];
  }

  if (s.contains('electric')) {
    return const [
      WorkSample(
        icon: Icons.electrical_services_rounded,
        label: 'Panel Upgrade',
      ),
      WorkSample(icon: Icons.power_rounded, label: 'Outlet Install'),
      WorkSample(icon: Icons.air_rounded, label: 'Ceiling Fan'),
      WorkSample(icon: Icons.toggle_on_rounded, label: 'Smart Switch'),
      WorkSample(icon: Icons.warning_rounded, label: 'Emergency Wire'),
      WorkSample(icon: Icons.security_rounded, label: 'Security Light'),
    ];
  }

  if (s.contains('carp')) {
    return const [
      WorkSample(icon: Icons.weekend_rounded, label: 'Custom Wardrobe'),
      WorkSample(icon: Icons.bed_rounded, label: 'Bed Frame'),
      WorkSample(icon: Icons.kitchen_rounded, label: 'Kitchen Cabinet'),
      WorkSample(icon: Icons.desktop_windows_rounded, label: 'Office Desk'),
      WorkSample(icon: Icons.door_back_door_rounded, label: 'Door Frame'),
      WorkSample(icon: Icons.shelves, label: 'Wall Shelving'),
    ];
  }

  if (s.contains('clean')) {
    return const [
      WorkSample(icon: Icons.cleaning_services_rounded, label: 'Deep Clean'),
      WorkSample(icon: Icons.kitchen_rounded, label: 'Kitchen Scrub'),
      WorkSample(icon: Icons.window_rounded, label: 'Window Clean'),
      WorkSample(icon: Icons.celebration_rounded, label: 'After Party'),
      WorkSample(icon: Icons.home_rounded, label: 'Move-in Ready'),
      WorkSample(icon: Icons.business_rounded, label: 'Office Clean'),
    ];
  }

  // Default (e.g., Painter)
  return const [
    WorkSample(icon: Icons.format_paint_rounded, label: 'Living Room'),
    WorkSample(icon: Icons.house_rounded, label: 'Exterior Wall'),
    WorkSample(icon: Icons.auto_awesome_rounded, label: 'Accent Wall'),
    WorkSample(icon: Icons.cabin_rounded, label: 'Ceiling Paint'),
    WorkSample(icon: Icons.business_center_rounded, label: 'Office Space'),
    WorkSample(icon: Icons.fence_rounded, label: 'Gate & Fence'),
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
    final primary = context.primary;
    final textColor = context.textColor;

    return Container(
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(sample.icon, color: primary, size: 28),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              sample.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
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
