class AppConstants {
  static const String general = "general";
  static const String business = "business";
  static const String entertainment = "entertainment";
  static const String health = "health";
  static const String science = "science";
  static const String sports = "sports";
  static const String technology = "technology";

  /// hero tags
  static const String heroTagSearch = "heroTagSearch";

  static String getDiscoverCategoryName(int index) {
    switch (index) {
      case 0:
        return general;
      case 1:
        return business;
      case 2:
        return entertainment;
      case 3:
        return health;
      case 4:
        return science;
      case 5:
        return sports;
      case 6:
        return technology;
      default:
        return general;
    }
  }
}
