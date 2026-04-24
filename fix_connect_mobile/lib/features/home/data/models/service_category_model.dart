import 'package:flutter/material.dart';

class ServiceCategoryModel {
  final String id;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final int artisanCount;
  final String startingPrice;
  final double avgRating;
  final String description;
  final List<String> popularServices;

  const ServiceCategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.artisanCount,
    required this.startingPrice,
    required this.avgRating,
    required this.description,
    required this.popularServices,
  });
}
