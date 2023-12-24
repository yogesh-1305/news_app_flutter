import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';

/// navigatorKey is used to navigate to a screen from anywhere in the app
final navigatorKey = GlobalKey<NavigatorState>();

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController>
    with WidgetsBindingObserver {
  /// This tag is used to log the lifecycle state of the app
  final String _tag = "AppController:";

  @override
  void initState() {
    /// Add observer before widget init
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    /// Remove observer before widget dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    LogHelper.logData("$_tag AppLifecycleState ===> $state");
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
