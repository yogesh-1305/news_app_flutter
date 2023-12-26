import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

abstract class GlobalSearchState {}

class GlobalSearchInitialState extends GlobalSearchState {
  GlobalSearchInitialState();
}

class GlobalSearchLoading extends GlobalSearchState {}

class GlobalSearchFailure extends GlobalSearchState {
  final String exceptionMessage;

  GlobalSearchFailure({required this.exceptionMessage});
}

class GlobalSearchSuccess extends GlobalSearchState {
  List<String> appliedFilters;
  final List<Articles> articles;

  GlobalSearchSuccess({this.appliedFilters = const [], required this.articles});
}

class GlobalSearchFilterState extends GlobalSearchState {
  String? sortBy;
  String? fromDate;
  String? toDate;

  GlobalSearchFilterState({
    this.sortBy,
    this.fromDate,
    this.toDate,
  });
}
