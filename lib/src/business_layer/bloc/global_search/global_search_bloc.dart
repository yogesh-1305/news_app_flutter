import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_state.dart';
import 'package:news_app_flutter/src/business_layer/network/api_constants.dart';
import 'package:news_app_flutter/src/business_layer/repository/global_search_repo.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/exception_extensions.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/string_extensions.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';

class GlobalSearchBloc extends Bloc<GlobalSearchEvent, GlobalSearchState> {
  final GlobalSearchRepository _globalSearchRepository =
      GlobalSearchRepository();

  List<Articles> articles = [];

  GlobalSearchBloc() : super(GlobalSearchInitialState()) {
    on<GlobalSearchEventDoSearch>(search);
    on<GlobalSearchEditFilterEvent>(filter);
  }

  Future<FutureOr<void>> search(
      GlobalSearchEventDoSearch event, Emitter<GlobalSearchState> emit) async {
    /// call initial api
    if (event.searchTerm.isEmpty) {
      emit(GlobalSearchInitialState());
    } else {
      if (event.page == 1) {
        emit(GlobalSearchLoading());
      }
      final response = await _globalSearchRepository.getSearchResults(
          page: event.page,
          searchTerms: event.searchTerm,
          sortBy: event.sortBy,
          fromDate: event.fromDate,
          toDate: event.toDate);
      if (response.status == ApiConstants.responseOk) {
        List<String> appliedFilters = [];
        if (event.sortBy != null && event.sortBy!.isNotEmpty) {
          appliedFilters.add(event.sortBy!.capitalize());
        }
        if (event.fromDate != null && event.fromDate!.isNotEmpty) {
          appliedFilters.add("From: ${event.fromDate!}");
        }
        if (event.toDate != null && event.toDate!.isNotEmpty) {
          appliedFilters.add("To: ${event.toDate!}");
        }
        articles.addAll(response.articles ?? []);
        emit(GlobalSearchSuccess(
            appliedFilters: appliedFilters, articles: articles));
      } else {
        emit(GlobalSearchFailure(
            exceptionMessage: response.exceptionType.message));
      }
    }
  }

  Future<FutureOr<void>> filter(GlobalSearchEditFilterEvent event,
      Emitter<GlobalSearchState> emit) async {
    /// call filter api
    emit(GlobalSearchFilterState(
      sortBy: event.sortBy,
      fromDate: event.fromDate,
      toDate: event.toDate,
    ));
  }
}
