import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  late AppLocalizations _localizations;

  @override
  Widget build(BuildContext context) {
    /// Initialize the localizations
    _localizations = AppLocalizations.of(context)!;

    /// Return the BaseWidget
    return BaseWidget(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_localizations.app_name),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }
}
