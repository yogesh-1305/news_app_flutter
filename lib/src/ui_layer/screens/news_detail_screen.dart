import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';

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
            background: Stack(
              children: [
                Hero(
                  tag: article.urlToImage ?? "assd",
                  child: Image.network(
                    article.urlToImage ?? "https://picsum.photos/200/300",
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(1),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            "News of the Day",
                            style:
                                AppStyles.caption.copyWith(color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    /// navigate to the article url
                    /// in the browser
                    // launch(article.url!);
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
