import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_state.dart';
import 'package:news_app_flutter/src/business_layer/repository/home_repo.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _homeRepo = HomeRepo();

  List<Articles> topArticlesCurrentLocation = [];
  List<Articles> topArticlesGlobal = [];

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialState);
    on<HomeNewsItemTapEvent>(homeNewsItemTapEvent);
    on<HomeViewAllNewsTapEvent>(homeViewAllTapEvent);
  }

  Future<FutureOr<void>> homeInitialState(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    /// call initial api
    emit(HomeLoadingState());
    final response = await _homeRepo.getTopHeadlines();
    if (response.status == "ok") {
      topArticlesCurrentLocation
          .addAll(response.articles as Iterable<Articles>);
      emit(HomeSuccessState(articles: topArticlesCurrentLocation));
    } else {
      emit(HomeFailureState(exceptionType: response.exceptionType));
    }
  }

  Future<FutureOr<void>> homeNewsItemTapEvent(
      HomeNewsItemTapEvent event, Emitter<HomeState> emit) async {
    emit(HomeNavigateToNewsDetailState(article: event.article));
  }

  Future<FutureOr<void>> homeViewAllTapEvent(
      HomeViewAllNewsTapEvent event, Emitter<HomeState> emit) async {
    emit(HomeNavigateToViewAllNewsState(category: event.category));
  }
}
