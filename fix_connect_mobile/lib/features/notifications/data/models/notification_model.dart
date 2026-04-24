import 'package:flutter/material.dart';

enum NotificationType {
  bookingConfirmed,
  bookingReminder,
  payment,
  promo,
  reviewRequest,
}

extension NotificationTypeX on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.bookingConfirmed: return Icons.check_circle_rounded;
      case NotificationType.bookingReminder:  return Icons.schedule_rounded;
      case NotificationType.payment:          return Icons.payments_rounded;
      case NotificationType.promo:            return Icons.local_offer_rounded;
      case NotificationType.reviewRequest:    return Icons.star_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.bookingConfirmed: return const Color(0xFF22C55E);
      case NotificationType.bookingReminder:  return const Color(0xFF0dd0f0);
      case NotificationType.payment:          return const Color(0xFF8B5CF6);
      case NotificationType.promo:            return const Color(0xFFFF9500);
      case NotificationType.reviewRequest:    return const Color(0xFFFFB800);
    }
  }
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}
