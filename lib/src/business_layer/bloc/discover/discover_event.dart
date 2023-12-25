import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

abstract class DiscoverEvents {}

class DiscoverGetContentEvent extends DiscoverEvents {
  int page;
  String category;
  String searchTerm = "";

  DiscoverGetContentEvent(
      {required this.page, required this.category, this.searchTerm = ""});
}

class DiscoverLoadingEvent extends DiscoverEvents {}

class DiscoverSuccessEvent extends DiscoverEvents {
  final TopHeadlinesResponse response;

  DiscoverSuccessEvent({required this.response});
}
