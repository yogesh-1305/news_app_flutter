import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/app_controller.dart';

class AppStyles {
  static TextStyle headline1 = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.5,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle headline2 = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle headline3 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle headline6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );

  static TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary,
  );
}
