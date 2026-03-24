import 'package:flutter/material.dart';

// 📚 CONCEPT: Enums are great for representing a fixed set of states.
// BookingStatus tracks the lifecycle of a booking.
// We add an extension to give each status a human-readable label and a color.
enum BookingStatus { upcoming, inProgress, completed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.upcoming:
        return const Color(0xFF0dd0f0);
      case BookingStatus.inProgress:
        return const Color(0xFFFF9500);
      case BookingStatus.completed:
        return const Color(0xFF22C55E);
      case BookingStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.upcoming:
        return Icons.schedule_rounded;
      case BookingStatus.inProgress:
        return Icons.construction_rounded;
      case BookingStatus.completed:
        return Icons.check_circle_rounded;
      case BookingStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
}

// 📚 CONCEPT: Data models (also called Entities) represent the shape of your data.
// They are plain Dart classes — no UI logic, just data and behavior.
// The 'const' constructor is a Flutter performance best practice: const objects
// are compiled at build time and reused, saving memory.
class BookingModel {
  final String id;
  final String artisanId;
  final String artisanName;
  final String artisanSpecialty;
  final String artisanInitials;
  final Color artisanBadgeColor;
  final String service;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final String totalPrice;
  final BookingStatus status;
  final String? notes; // nullable — notes are optional

  const BookingModel({
    required this.id,
    required this.artisanId,
    required this.artisanName,
    required this.artisanSpecialty,
    required this.artisanInitials,
    required this.artisanBadgeColor,
    required this.service,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.totalPrice,
    required this.status,
    this.notes,
  });
}
