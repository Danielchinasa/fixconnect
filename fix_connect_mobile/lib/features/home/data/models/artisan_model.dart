import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
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
  final bool isFeatured;

  /// Remote photo URL — null when the artisan hasn't uploaded one yet.
  final String? avatarUrl;

  // Extended profile fields
  final String location;
  final String bio;
  final int completedJobs;
  final String responseTime;
  final Map<String, String?> weeklySchedule;
  final List<ServiceCategoryModel> categories;
  final String phone;

  const ArtisanModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.reviews = 0,
    required this.startingPrice,
    required this.isVerified,
    required this.isOnline,
    this.isFeatured = false,
    this.avatarUrl,
    this.location = '',
    this.bio = '',
    this.completedJobs = 0,
    this.responseTime = 'Within 24 hours',
    this.weeklySchedule = const {},
    this.categories = const [],
    this.phone = '',
  });

  // ── Computed UI helpers (no API field needed) ───────────────────────────────

  /// Two uppercase initials derived from [name].
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Consistent avatar background colour, deterministically derived from [id].
  static const _avatarColors = [
    Color(0xFF0dd0f0), // cyan / primary
    Color(0xFF22C55E), // green
    Color(0xFF8B5CF6), // purple
    Color(0xFFF97316), // orange
    Color(0xFFEF4444), // red
    Color(0xFFEC4899), // pink
  ];

  Color get badgeColor {
    final hash = id.codeUnits.fold(0, (a, b) => a + b);
    return _avatarColors[hash % _avatarColors.length];
  }

  // ── Factory ─────────────────────────────────────────────────────────────────

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    // Name comes from the nested user object returned by the API.
    final user = json['user'] as Map<String, dynamic>?;
    final firstName = user?['firstName'] as String? ?? '';
    final lastName = user?['lastName'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    // API sends price as an int (e.g. 5000); format for display as "₦5,000".
    final rawPrice = json['startingPrice'];
    final String formattedPrice;
    if (rawPrice is num) {
      formattedPrice = '₦${_formatNumber(rawPrice.toInt())}';
    } else {
      formattedPrice = rawPrice?.toString() ?? '';
    }

    return ArtisanModel(
      id: json['id'] as String,
      name: fullName.isEmpty ? 'Unknown' : fullName,
      specialty: json['specialty'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviewCount'] as int? ?? json['reviews'] as int? ?? 0,
      startingPrice: formattedPrice,
      isVerified: json['isVerified'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      avatarUrl: user?['avatarUrl'] as String?,
      phone: user?['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      completedJobs: json['completedJobs'] as int? ?? 0,
      responseTime: json['responseTime'] as String? ?? 'Within 24 hours',
      weeklySchedule: _parseWeeklySchedule(json['weeklySchedule']),
      categories: _parseCategories(json['categories']),
    );
  }

  static List<ServiceCategoryModel> _parseCategories(dynamic raw) {
    if (raw is! List) return [];
    final result = <ServiceCategoryModel>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        // Each entry is { artisanProfileId, categoryId, category: { id, name, iconSvg } }
        final cat = item['category'] as Map<String, dynamic>?;
        if (cat != null) result.add(ServiceCategoryModel.fromJson(cat));
      }
    }
    return result;
  }

  static const _fullDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static Map<String, String?> _parseWeeklySchedule(dynamic raw) {
    if (raw is! Map) return {};
    final result = <String, String?>{};
    for (final day in _fullDayNames) {
      if (raw.containsKey(day)) {
        result[day] = raw[day] as String?;
      }
    }
    return result;
  }

  /// Whether the artisan is available today (non-null entry in weeklySchedule).
  bool get isTodayOpen {
    final today = _fullDayNames[DateTime.now().weekday - 1];
    return weeklySchedule[today] != null;
  }

  /// Today's hours string, or empty string if closed.
  String get todayOpenTime {
    final today = _fullDayNames[DateTime.now().weekday - 1];
    return weeklySchedule[today] ?? '';
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
    'isFeatured': isFeatured,
    'avatarUrl': avatarUrl,
    'location': location,
    'bio': bio,
    'completedJobs': completedJobs,
    'responseTime': responseTime,
    'weeklySchedule': weeklySchedule,
    'phone': phone,
  };

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Formats an integer with comma thousand-separators (e.g. 5000 → "5,000").
  static String _formatNumber(int n) {
    final s = n.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }
}
