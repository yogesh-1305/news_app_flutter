import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {}

class HomeLoadingEvent extends HomeEvent {}

class HomeSuccessEvent extends HomeEvent {
  final TopHeadlinesResponse response;

  HomeSuccessEvent({required this.response});
}
