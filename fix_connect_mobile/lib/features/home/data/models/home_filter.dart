class HomeFilter {
  final String? category;
  final double minRating;
  final bool verifiedOnly;
  final int? maxDistance;

  const HomeFilter({
    this.category,
    this.minRating = 0,
    this.verifiedOnly = false,
    this.maxDistance,
  });

  static const empty = HomeFilter();

  bool get isActive =>
      category != null || minRating > 0 || verifiedOnly || maxDistance != null;

  HomeFilter reset() => const HomeFilter();
}
