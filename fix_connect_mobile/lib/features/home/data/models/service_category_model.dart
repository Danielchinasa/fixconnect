/// Domain model for a service category returned by GET /service-categories.
class ServiceCategoryModel {
  final String id;
  final String name;
  final String? iconSvg;
  final String? description;
  final bool isActive;
  final int? artisanCount;
  final DateTime? createdAt;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    this.iconSvg,
    this.description,
    this.isActive = true,
    this.artisanCount,
    this.createdAt,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconSvg: json['iconSvg'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      artisanCount: json['artisanCount'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
