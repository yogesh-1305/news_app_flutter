import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/business_layer/bloc/dashboard/dashboard_cubit.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/discover_tab.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/home_tab.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/profile_tab.dart';

/// the dashboard screen
/// this screen will be shown after the splash screen
/// this contains the bottom navigation bar
/// with 3 tabs -> home, discover, profile
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    /// Return the BaseWidget
    return BaseWidget(
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  /// Build the body of the scaffold with the indexed stack
  /// The indexed stack will show the screen according to the index
  /// of the bottom navigation bar
  Widget _buildBody(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(builder: (context, index) {
      LogHelper.logData("Dashboard index ===> $index");
      return IndexedStack(
        index: index,
        children: const [
          HomeTab(),
          DiscoverTab(),
          ProfileTab(),
        ],
      );
    });
  }

  /// Build the bottom navigation bar
  /// The bottom navigation bar will change the index of the indexed stack
  /// according to the index of the bottom navigation bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BlocBuilder<DashboardCubit, int>(builder: (context, index) {
      return BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: (index) {
          context.read<DashboardCubit>().changeTab(index);
        },
        items: [
          /// home
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: localizations.home,
          ),

          /// discover
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_rounded),
            label: localizations.discover,
          ),

          /// profile
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_2_outlined),
            label: localizations.profile,
          ),
        ],
      );
    });
  }
}
