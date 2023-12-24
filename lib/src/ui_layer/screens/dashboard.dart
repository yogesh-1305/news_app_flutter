import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/business_layer/bloc/dashboard/dashboard_cubit.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/home_tab.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/profile_tab.dart';
import 'package:news_app_flutter/src/ui_layer/screens/dashboard_tabs/search_tab.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  late AppLocalizations _localizations;

  @override
  Widget build(BuildContext context) {
    /// Initialize the localizations
    _localizations = AppLocalizations.of(context)!;

    debugPrint("Dashboard build");

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
          SearchTab(),
          ProfileTab(),
        ],
      );
    });
  }

  /// Build the bottom navigation bar
  /// The bottom navigation bar will change the index of the indexed stack
  /// according to the index of the bottom navigation bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(builder: (context, index) {
      return BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: (index) {
          context.read<DashboardCubit>().changeTab(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: _localizations.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: _localizations.profile,
          ),
        ],
      );
    });
  }
}
