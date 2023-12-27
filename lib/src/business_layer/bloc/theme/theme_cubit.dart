import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/src/business_layer/database/user_state_hive_helper.dart';

class ThemeCubit extends Cubit<ThemeMode?> {
  ThemeCubit() : super(null);

  void changeTheme(ThemeMode themeMode) async {
    emit(themeMode);
    await UserStateHiveHelper.instance.setThemeMode(themeMode);
  }
}
