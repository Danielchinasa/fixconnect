import 'package:flutter/material.dart';

// 📚 CONCEPT: Enums are great for representing a fixed set of states.
// BookingStatus tracks the lifecycle of a booking.
// We add an extension to give each status a human-readable label and a color.
enum BookingStatus {
  /// Customer sent a request — awaiting artisan quote.
  pending,

  /// Artisan has sent a price quote — awaiting customer acceptance.
  quoteSent,

  /// Artisan declined the request (terminal).
  declined,

  /// Customer accepted the quote — awaiting payment.
  confirmed,

  /// Customer cancelled after accepting (terminal).
  cancelled,

  /// Payment held in escrow — artisan working.
  inProgress,

  /// Artisan marked job done — escrow released.
  completed,
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.quoteSent:
        return 'Quote Sent';
      case BookingStatus.declined:
        return 'Declined';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return const Color(0xFF0dd0f0);
      case BookingStatus.quoteSent:
        return const Color(0xFF8B5CF6);
      case BookingStatus.declined:
        return const Color(0xFFEF4444);
      case BookingStatus.confirmed:
        return const Color(0xFF22C55E);
      case BookingStatus.cancelled:
        return const Color(0xFFEF4444);
      case BookingStatus.inProgress:
        return const Color(0xFFFF9500);
      case BookingStatus.completed:
        return const Color(0xFF22C55E);
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.hourglass_top_rounded;
      case BookingStatus.quoteSent:
        return Icons.request_quote_rounded;
      case BookingStatus.declined:
        return Icons.cancel_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_rounded;
      case BookingStatus.cancelled:
        return Icons.cancel_rounded;
      case BookingStatus.inProgress:
        return Icons.construction_rounded;
      case BookingStatus.completed:
        return Icons.task_alt_rounded;
    }
  }

  /// Whether this status is a terminal state (no further transitions).
  bool get isTerminal =>
      this == BookingStatus.declined || this == BookingStatus.cancelled;

  /// Whether the customer still has an action to take.
  bool get awaitingCustomer =>
      this == BookingStatus.quoteSent || this == BookingStatus.confirmed;
}

// 📚 CONCEPT: Data models (also called Entities) represent the shape of your data.
// They are plain Dart classes — no UI logic, just data and behavior.
// The 'const' constructor is a Flutter performance best practice: const objects
// are compiled at build time and reused, saving memory.
class BookingModel {
  final String id;
  final String artisanId;
  final String artisanName;

  /// The artisan's profile specialty title (e.g. "Master Plumber").
  /// Comes from `artisanProfile.specialty` on the API response.
  final String artisanSpecialty;

  /// The service category name the booking was made under (e.g. "Plumbing").
  /// Resolved from: booking.category.name → artisanProfile.categories[0].category.name
  /// → artisanProfile.specialty → fallback "Service".
  final String service;

  /// The customer's free-text description of the job they need done.
  /// Maps to `serviceDescription` on the API request/response.
  final String? serviceDescription;

  final String artisanInitials;
  final Color artisanBadgeColor;

  /// The customer's full name — populated only on artisan-side responses.
  final String? customerName;

  /// Two uppercase initials derived from [customerName].
  final String? customerInitials;

  /// The customer's phone number — populated only on artisan-side responses.
  final String? customerPhone;

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
    required this.service,
    this.serviceDescription,
    required this.artisanInitials,
    required this.artisanBadgeColor,
    this.customerName,
    this.customerInitials,
    this.customerPhone,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.totalPrice,
    required this.status,
    this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Artisan info may be nested under artisanProfile → user
    final artisanProfile =
        json['artisanProfile'] as Map<String, dynamic>? ?? {};
    final artisanUser = artisanProfile['user'] as Map<String, dynamic>? ?? {};
    final firstName = (artisanUser['firstName'] as String? ?? '').trim();
    final lastName = (artisanUser['lastName'] as String? ?? '').trim();
    final artisanName = '$firstName $lastName'.trim().isEmpty
        ? 'Artisan'
        : '$firstName $lastName'.trim();
    final initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
            .toUpperCase();

    // Customer info — present on artisan-side responses (GET /bookings/artisan).
    final customerRaw = json['customer'] as Map<String, dynamic>?;
    final cFirst = (customerRaw?['firstName'] as String? ?? '').trim();
    final cLast = (customerRaw?['lastName'] as String? ?? '').trim();
    final customerFullName = '$cFirst $cLast'.trim();
    final customerInitials =
        '${cFirst.isNotEmpty ? cFirst[0] : ''}${cLast.isNotEmpty ? cLast[0] : ''}'
            .toUpperCase();
    final customerPhone = customerRaw?['phone'] as String?;

    // Service name: try booking's own category first (most specific),
    // then artisan's first category, then artisan's specialty text, then fallback.
    final bookingCategory = json['category'] as Map<String, dynamic>?;
    final artisanSpecialty = artisanProfile['specialty'] as String? ?? '';
    final categoryName =
        bookingCategory?['name'] as String? ??
        ((artisanProfile['categories'] as List?)?.firstOrNull
                as Map<String, dynamic>?)?['category']?['name']
            as String? ??
        (artisanSpecialty.isNotEmpty ? artisanSpecialty : null) ??
        'Service';

    // Status mapping from API snake_case strings
    final statusStr = (json['status'] as String? ?? 'pending').toLowerCase();
    final status = _parseStatus(statusStr);

    // Scheduled date
    final scheduledDate =
        DateTime.tryParse(json['scheduledDate'] as String? ?? '') ??
        DateTime.now();

    // Badge colour — cycle by artisan id hash
    final badgeColors = [
      const Color(0xFF6366F1),
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF0EA5E9),
    ];
    final colorIdx =
        (artisanProfile['id'] as String? ?? '').hashCode.abs() %
        badgeColors.length;

    return BookingModel(
      id: json['id'] as String? ?? '',
      artisanId: artisanProfile['id'] as String? ?? '',
      artisanName: artisanName,
      artisanSpecialty: artisanSpecialty,
      artisanInitials: initials.isEmpty ? 'A' : initials,
      artisanBadgeColor: badgeColors[colorIdx],
      service: categoryName,
      serviceDescription: json['serviceDescription'] as String?,
      customerName: customerFullName.isEmpty ? null : customerFullName,
      customerInitials: customerInitials.isEmpty ? null : customerInitials,
      customerPhone: customerPhone,
      scheduledDate: scheduledDate,
      timeSlot: json['timeSlot'] as String? ?? '',
      address: json['address'] as String? ?? '',
      totalPrice: _formatPrice(json['totalAmount'] ?? json['quotedPrice']),
      status: status,
      notes: json['notes'] as String?,
    );
  }

  static String _formatPrice(dynamic raw) {
    if (raw == null) return 'Awaiting quote';
    final num value = raw is num ? raw : num.tryParse(raw.toString()) ?? 0;
    // Format with thousands separators: 7500 → ₦7,500
    final parts = value.toStringAsFixed(0).split('');
    final buf = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buf.write(',');
      buf.write(parts[i]);
    }
    return '₦$buf';
  }

  static BookingStatus _parseStatus(String raw) {
    switch (raw) {
      case 'quote_sent':
      case 'quotesent':
        return BookingStatus.quoteSent;
      case 'declined':
        return BookingStatus.declined;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'in_progress':
      case 'inprogress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }
}
