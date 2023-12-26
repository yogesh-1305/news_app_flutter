import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';

abstract class DiscoverState {
  const DiscoverState();
}

class DiscoverInitialState extends DiscoverState {
  const DiscoverInitialState();
}

class DiscoverLoadingState extends DiscoverState {
  const DiscoverLoadingState();
}

class DiscoverPaginationLoadingState extends DiscoverState {
  const DiscoverPaginationLoadingState();
}

class DiscoverSuccessState extends DiscoverState {
  List<Articles> articles;
  String category;

  DiscoverSuccessState({required this.articles, required this.category});
}

class DiscoverFailureState extends DiscoverState {
  final String exceptionMessage;

  DiscoverFailureState({required this.exceptionMessage});
}
