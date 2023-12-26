import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_flutter/src/bloc_registration.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/data_layer/res/app_themes.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard.dart';

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
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: _buildApp(context),
    );
  }

  Widget _buildApp(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// close the keyboard if tapped anywhere on the app
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocProvider(
        providers: BlocRegistration.providers,
        child: MaterialApp(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.app_name,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          themeMode: ThemeMode.system,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Dashboard(),
        ),
      ),
    );
  }
}
