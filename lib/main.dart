import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_flutter/src/app_controller.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/flavor_configuration_helper.dart';

import 'src/business_layer/database/hive_database_helper.dart';

/// The entrypoint for the Flutter application.
void main() async {
  /// You only need to call this method if you need the binding to be
  /// initialized before calling [runApp].
  WidgetsFlutterBinding.ensureInitialized();

  /// Ensuring Size of the phone in UI Design
  await ScreenUtil.ensureScreenSize();

  await HiveHelper.initializeHiveAndRegisterAdapters();
  await SecureStorageHelper.instance.generateEncryptionKey();

  /// setting the flavor config for the app
  /// flavors -> dev, staging, production
  /// default flavor is dev
  FlavorConfig.setServerConfig();

  /// Runs the app with the provided widget as the root of the widget tree.
  runApp(const AppController());
}
