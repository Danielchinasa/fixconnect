class MyReview {
  const MyReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.counterpartyName,
    this.serviceName,
  });

  final String id;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  final String counterpartyName;
  final String? serviceName;

  static String _stringOrEmpty(dynamic v) {
    if (v == null) return '';
    if (v is String) return v.trim();
    return v.toString().trim();
  }

  static double _doubleOrZero(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    final raw = v.toString();
    return DateTime.tryParse(raw);
  }

  static String _nameFromUserMap(Map<String, dynamic>? user) {
    if (user == null) return '';
    final direct = _stringOrEmpty(user['name']);
    if (direct.isNotEmpty) return direct;

    final first = _stringOrEmpty(user['firstName']);
    final last = _stringOrEmpty(user['lastName']);
    final full = '$first $last'.trim();
    return full;
  }

  factory MyReview.fromJson(Map<String, dynamic> json) {
    final id = _stringOrEmpty(json['id']).isNotEmpty
        ? _stringOrEmpty(json['id'])
        : _stringOrEmpty(json['_id']);

    final artisanMap = json['artisan'] is Map<String, dynamic>
        ? json['artisan'] as Map<String, dynamic>
        : null;
    final reviewerMap = json['reviewer'] is Map<String, dynamic>
        ? json['reviewer'] as Map<String, dynamic>
        : null;

    final counterpartyName = _nameFromUserMap(artisanMap).isNotEmpty
        ? _nameFromUserMap(artisanMap)
        : _nameFromUserMap(reviewerMap);

    final serviceMap = json['service'] is Map<String, dynamic>
        ? json['service'] as Map<String, dynamic>
        : null;

    return MyReview(
      id: id,
      rating: _doubleOrZero(json['rating'] ?? json['stars']),
      comment: _stringOrEmpty(
        json['comment'] ?? json['review'] ?? json['message'] ?? json['text'],
      ),
      createdAt: _parseDate(
        json['createdAt'] ?? json['created_at'] ?? json['date'],
      ),
      counterpartyName: counterpartyName.isNotEmpty
          ? counterpartyName
          : 'Customer/Artisan',
      serviceName: _stringOrEmpty(serviceMap?['name']).isEmpty
          ? null
          : _stringOrEmpty(serviceMap?['name']),
    );
  }
}
