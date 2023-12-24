import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {}

class HomeNewsItemTapEvent extends HomeEvent {
  final Articles article;

  HomeNewsItemTapEvent({required this.article});
}

class HomeViewAllNewsTapEvent extends HomeEvent {
  final String category;

  HomeViewAllNewsTapEvent({required this.category});
}
