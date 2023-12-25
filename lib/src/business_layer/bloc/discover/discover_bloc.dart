import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_state.dart';
import 'package:news_app_flutter/src/business_layer/repository/discover_repo.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/exception_exteisions.dart';

class DiscoverBloc extends Bloc<DiscoverEvents, DiscoverState> {
  final DiscoverRepo _discoverRepo = DiscoverRepo();

  DiscoverBloc() : super(const DiscoverInitialState()) {
    on<DiscoverGetContentEvent>(discoverInitialState);
  }

  Future<FutureOr<void>> discoverInitialState(
      DiscoverGetContentEvent event, Emitter<DiscoverState> emit) async {
    /// call initial api
    if (event.page == 1) {
      emit(const DiscoverLoadingState());
    } /*else {
      emit(const DiscoverPaginationLoadingState());
    }*/
    final response = await _discoverRepo.getDiscoverContent(
        page: event.page, category: event.category);
    if (response.status == "ok") {
      emit(DiscoverSuccessState(
          category: event.category, articles: response.articles ?? []));
    } else {
      emit(DiscoverFailureState(
          exceptionMessage: response.exceptionType.message));
    }
  }
}
