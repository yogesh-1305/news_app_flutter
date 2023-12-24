import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

abstract class HomeState {
  const HomeState();
}

/// ui states
class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<Articles> articles;

  HomeSuccessState({required this.articles});
}

class HomeFailureState extends HomeState {
  ExceptionType exceptionType;

  HomeFailureState({required this.exceptionType});
}

/// actions states
class HomeActionsState extends HomeState {}

class HomeNavigateToNewsDetailState extends HomeActionsState {
  final Articles article;

  HomeNavigateToNewsDetailState({required this.article});
}

class HomeNavigateToViewAllNewsState extends HomeActionsState {
  final String category;

  HomeNavigateToViewAllNewsState({required this.category});
}
