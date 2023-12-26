import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_news_header.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_web_view_screen.dart';

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
      slivers: [
        SliverAppBar(
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
                  onPressed: () {
                    /// navigate to the article urls
                    /// in the browser
                    context.push(const CommonWebViewScreen());
                  },
                  child: const Text("Read Full Article"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
