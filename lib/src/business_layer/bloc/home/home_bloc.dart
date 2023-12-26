import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_state.dart';
import 'package:news_app_flutter/src/business_layer/network/api_constants.dart';
import 'package:news_app_flutter/src/business_layer/repository/home_repo.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _homeRepo = HomeRepo();

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialState);
  }

  Future<FutureOr<void>> homeInitialState(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    /// call initial api
    emit(HomeLoadingState());
    final response = await _homeRepo.getHomeScreenNewsContent();
    if (response.status == ApiConstants.responseOk) {
      emit(HomeSuccessState(response: response));
    } else {
      emit(HomeFailureState(exceptionType: response.exceptionType));
    }
  }
}
