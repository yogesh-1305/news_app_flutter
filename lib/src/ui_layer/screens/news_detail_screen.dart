import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_news_header.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key, required this.article});

  final Articles article;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          leading: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          expandedHeight: MediaQuery.sizeOf(context).height * 0.4,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              background: CommonNewsHeader(
                  localizations: AppLocalizations.of(context)!,
                  showLearnMoreButton: false,
                  article: article,
                  showBottomRoundContainer: true,
                  borderRadius: BorderRadius.circular(0))),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  article.title ?? "",
                  style: AppStyles.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  article.description ?? "",
                  style: AppStyles.subtitle1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  article.content ?? "",
                  style: AppStyles.subtitle2,
                ),
              ),

              /// read full article button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    /// navigate to the article urls
                    /// in the browser
                    _launchUrl(article.url ?? "");
                  },
                  child: Text(AppLocalizations.of(context)!.read_full_article),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
