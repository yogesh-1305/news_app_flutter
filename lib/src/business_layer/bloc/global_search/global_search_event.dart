abstract class GlobalSearchEvent {}

class GlobalSearchEditFilterEvent extends GlobalSearchEvent {
  String? searchTerm;
  String? sortBy;
  final String? fromDate;
  final String? toDate;

  GlobalSearchEditFilterEvent({
    this.searchTerm,
    this.sortBy,
    this.fromDate,
    this.toDate,
  });
}

class GlobalSearchEventClearFilters extends GlobalSearchEvent {
  final String searchTerm;

  GlobalSearchEventClearFilters({required this.searchTerm});
}

class GlobalSearchEventClearSearch extends GlobalSearchEvent {}

class GlobalSearchEventDoSearch extends GlobalSearchEvent {
  final int page;
  final String searchTerm;
  final String? sortBy;
  final String? fromDate;
  final String? toDate;

  GlobalSearchEventDoSearch({
    required this.page,
    required this.searchTerm,
    this.sortBy,
    this.fromDate,
    this.toDate,
  });
}
