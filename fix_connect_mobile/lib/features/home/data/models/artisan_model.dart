import 'package:flutter/material.dart';

class ArtisanModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final String startingPrice;
  final bool isVerified;
  final bool isOnline;
  final Color badgeColor;
  final String initials;

  const ArtisanModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.startingPrice,
    required this.isVerified,
    required this.isOnline,
    required this.badgeColor,
    required this.initials,
  });

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    return ArtisanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      startingPrice: json['startingPrice'] as String,
      isVerified: json['isVerified'] as bool,
      isOnline: json['isOnline'] as bool,
      badgeColor: Color(json['badgeColorValue'] as int),
      initials: json['initials'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'rating': rating,
    'reviews': reviews,
    'startingPrice': startingPrice,
    'isVerified': isVerified,
    'isOnline': isOnline,
    'badgeColorValue': badgeColor.value,
    'initials': initials,
  };
}
