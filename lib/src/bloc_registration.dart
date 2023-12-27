import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/dashboard/dashboard_cubit.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/theme/theme_cubit.dart';
import 'package:provider/single_child_widget.dart';

class BlocRegistration {
  static List<SingleChildWidget> providers = [
    BlocProvider<ThemeCubit>(
      create: (BuildContext context) => ThemeCubit(),
    ),
    BlocProvider<DashboardCubit>(
      create: (BuildContext context) => DashboardCubit(),
    ),
    BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
    ),
    BlocProvider<DiscoverBloc>(
      create: (BuildContext context) => DiscoverBloc(),
    ),
    BlocProvider<GlobalSearchBloc>(
      create: (BuildContext context) => GlobalSearchBloc(),
    ),
  ];
}
