import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:flutter/material.dart';

class HomeMockDatasource {
  HomeMockDatasource._();

  static List<ArtisanModel> getTopArtisans() => const [
    ArtisanModel(
      id: '1',
      name: 'Emeka Okafor',
      specialty: 'Master Plumber',
      rating: 4.9,
      reviews: 128,
      startingPrice: '₦3,500',
      isVerified: true,
      isOnline: true,
      badgeColor: AppColors.primaryLight,
      initials: 'EO',
    ),
    ArtisanModel(
      id: '2',
      name: 'Amina Bello',
      specialty: 'Electrician',
      rating: 4.8,
      reviews: 97,
      startingPrice: '₦4,000',
      isVerified: true,
      isOnline: false,
      badgeColor: AppColors.secondary,
      initials: 'AB',
    ),
    ArtisanModel(
      id: '3',
      name: 'Chukwudi Nze',
      specialty: 'Carpenter',
      rating: 4.7,
      reviews: 63,
      startingPrice: '₦2,800',
      isVerified: false,
      isOnline: true,
      badgeColor: Color(0xFFFF9500),
      initials: 'CN',
    ),
    ArtisanModel(
      id: '4',
      name: 'Fatima Musa',
      specialty: 'House Cleaner',
      rating: 5.0,
      reviews: 214,
      startingPrice: '₦2,000',
      isVerified: true,
      isOnline: true,
      badgeColor: AppColors.primaryLight,
      initials: 'FM',
    ),
    ArtisanModel(
      id: '5',
      name: 'Tunde Adeyemi',
      specialty: 'Painter',
      rating: 4.6,
      reviews: 45,
      startingPrice: '₦3,200',
      isVerified: true,
      isOnline: false,
      badgeColor: AppColors.secondary,
      initials: 'TA',
    ),
  ];

  static List<String> getLocations() => const [
    'Lagos, Nigeria',
    'Abuja, Nigeria',
    'Port Harcourt, Nigeria',
    'Kano, Nigeria',
    'Ibadan, Nigeria',
    'Enugu, Nigeria',
  ];
}
