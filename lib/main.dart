import 'package:flutter/cupertino.dart';
import 'package:news_app_flutter/src/app_controller.dart';

/// The entrypoint for the Flutter application.
void main() {
  /// You only need to call this method if you need the binding to be
  /// initialized before calling [runApp].
  WidgetsFlutterBinding.ensureInitialized();

  /// Runs the app with the provided widget as the root of the widget tree.
  runApp(const AppController());
}
