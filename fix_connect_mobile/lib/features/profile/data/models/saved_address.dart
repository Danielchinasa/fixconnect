class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.isDefault,
    this.createdAt,
  });

  final String id;
  final String label;
  final String address;
  final String city;
  final String state;
  final bool isDefault;
  final DateTime? createdAt;

  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
    id: json['id'] as String,
    label: json['label'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    isDefault: json['isDefault'] as bool? ?? false,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'address': address,
    'city': city,
    'state': state,
    'isDefault': isDefault,
  };

  SavedAddress copyWith({
    String? label,
    String? address,
    String? city,
    String? state,
    bool? isDefault,
  }) => SavedAddress(
    id: id,
    label: label ?? this.label,
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt,
  );
}
