import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:flutter/material.dart';

class ServicesMockDatasource {
  ServicesMockDatasource._();

  static List<ServiceCategoryModel> getCategories() => const [
    ServiceCategoryModel(
      id: 'plumbing',
      label: 'Plumbing',
      icon: Icons.water_drop_outlined,
      gradientColors: [Color(0xFF0ea5e9), Color(0xFF0dd0f0)],
      artisanCount: 142,
      startingPrice: '₦3,500',
      avgRating: 4.7,
      description:
          'Expert plumbers for all pipe, drain, and fixture needs. From leaky taps to full bathroom installations, our verified professionals get it done right.',
      popularServices: [
        'Pipe Repair',
        'Drain Cleaning',
        'Toilet Installation',
        'Water Heater',
        'Leak Detection',
      ],
    ),
    ServiceCategoryModel(
      id: 'electrical',
      label: 'Electrical',
      icon: Icons.bolt_rounded,
      gradientColors: [Color(0xFFf97316), Color(0xFFfbbf24)],
      artisanCount: 98,
      startingPrice: '₦4,000',
      avgRating: 4.8,
      description:
          'Licensed electricians for wiring, installations, repairs and power solutions. Safety-first approach for homes and offices.',
      popularServices: [
        'Wiring & Rewiring',
        'Socket Repair',
        'Lighting Install',
        'Generator Setup',
        'Power Surge Fix',
      ],
    ),
    ServiceCategoryModel(
      id: 'carpentry',
      label: 'Carpentry',
      icon: Icons.handyman_outlined,
      gradientColors: [Color(0xFFd97706), Color(0xFF7c2d12)],
      artisanCount: 76,
      startingPrice: '₦5,000',
      avgRating: 4.6,
      description:
          'Skilled carpenters for furniture, cabinets, doors, flooring and custom woodwork. Precision craftsmanship at fair prices.',
      popularServices: [
        'Furniture Repair',
        'Door Installation',
        'Cabinet Fitting',
        'Wood Flooring',
        'Custom Woodwork',
      ],
    ),
    ServiceCategoryModel(
      id: 'cleaning',
      label: 'Cleaning',
      icon: Icons.cleaning_services_outlined,
      gradientColors: [Color(0xFF14b8a6), Color(0xFF16a34a)],
      artisanCount: 215,
      startingPrice: '₦2,500',
      avgRating: 4.9,
      description:
          'Professional cleaning teams for homes, offices, after-party cleaning and deep cleans. Spotless results, every time.',
      popularServices: [
        'Deep Clean',
        'Office Cleaning',
        'After-Party Clean',
        'Carpet Cleaning',
        'Window Washing',
      ],
    ),
    ServiceCategoryModel(
      id: 'painting',
      label: 'Painting',
      icon: Icons.format_paint_outlined,
      gradientColors: [Color(0xFFa855f7), Color(0xFFdb2777)],
      artisanCount: 88,
      startingPrice: '₦3,000',
      avgRating: 4.5,
      description:
          'Expert painters for interior and exterior walls, ceilings, fences and decorative finishes. Premium results with quality materials.',
      popularServices: [
        'Interior Painting',
        'Exterior Painting',
        'Ceiling Paint',
        'Fence Painting',
        'Texture & Finishes',
      ],
    ),
    ServiceCategoryModel(
      id: 'hvac',
      label: 'HVAC',
      icon: Icons.ac_unit_outlined,
      gradientColors: [Color(0xFF6366f1), Color(0xFF0ea5e9)],
      artisanCount: 54,
      startingPrice: '₦6,000',
      avgRating: 4.7,
      description:
          'AC installation, maintenance and repair specialists. Keep your space cool, comfortable and energy-efficient year-round.',
      popularServices: [
        'AC Installation',
        'AC Repair',
        'AC Servicing',
        'Gas Refill',
        'Duct Cleaning',
      ],
    ),
    ServiceCategoryModel(
      id: 'landscaping',
      label: 'Landscaping',
      icon: Icons.grass_outlined,
      gradientColors: [Color(0xFF16a34a), Color(0xFF65a30d)],
      artisanCount: 41,
      startingPrice: '₦4,500',
      avgRating: 4.4,
      description:
          'Transform your outdoor spaces with professional landscaping and gardening. From lawn care to full garden design.',
      popularServices: [
        'Lawn Mowing',
        'Garden Design',
        'Tree Trimming',
        'Irrigation Setup',
        'Planting & Seeds',
      ],
    ),
    ServiceCategoryModel(
      id: 'moving',
      label: 'Moving',
      icon: Icons.local_shipping_outlined,
      gradientColors: [Color(0xFF7c3aed), Color(0xFFbe185d)],
      artisanCount: 63,
      startingPrice: '₦15,000',
      avgRating: 4.6,
      description:
          'Safe, reliable moving services for homes, offices and long-distance relocations. We handle your belongings with care.',
      popularServices: [
        'Home Moving',
        'Office Moving',
        'Packing Service',
        'Furniture Moving',
        'Long Distance',
      ],
    ),
    ServiceCategoryModel(
      id: 'mechanic',
      label: 'Mechanic',
      icon: Icons.car_repair_rounded,
      gradientColors: [Color(0xFF475569), Color(0xFF0f172a)],
      artisanCount: 72,
      startingPrice: '₦3,500',
      avgRating: 4.5,
      description:
          'Certified auto mechanics for car repairs, diagnostics, servicing and emergency roadside assistance. Keep your car running smoothly.',
      popularServices: [
        'Car Servicing',
        'Engine Repair',
        'Tyre Change',
        'Car Diagnostics',
        'AC Repair',
      ],
    ),
  ];
}
