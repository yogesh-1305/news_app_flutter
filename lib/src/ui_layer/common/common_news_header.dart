import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';
import 'package:news_app_flutter/src/data_layer/res/app_colors.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

class CommonNewsHeader extends StatelessWidget {
  const CommonNewsHeader({
    super.key,
    required this.localizations,
    required this.article,
    this.borderRadius,
    this.showLearnMoreButton = true,
    this.showBottomRoundContainer = false,
    this.showNewsOfTheDayTag = false,
  });

  /// localizations object
  final AppLocalizations localizations;

  /// article object to show the news
  final Articles article;

  /// border radius for the image
  final BorderRadiusGeometry? borderRadius;

  /// show learn more button
  final bool showLearnMoreButton;

  /// show bottom round container
  final bool showBottomRoundContainer;

  final bool showNewsOfTheDayTag;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context, article);
  }

  /// This is the top news of the day
  /// This is a stack with an image and a gradient
  /// The gradient is used to show the title and the learn more button
  Widget _buildBody(BuildContext context, Articles article) {
    return ClipRRect(
      borderRadius: borderRadius ??
          const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
      child: Stack(
        children: [
          /// background image
          _backgroundImage(context),

          /// foreground data
          /// gradient with tag, title and learn more button
          _foregroundData(context),
        ],
      ),
    );
  }

  Widget _backgroundImage(BuildContext context) {
    return Image.network(
      article.urlToImage ?? "https://picsum.photos/200/300",
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.45,
      fit: BoxFit.fill,
    );
  }

  Widget _foregroundData(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.stackShadowGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// tag for the news
            if (showNewsOfTheDayTag) _tag(context),

            /// title of the news
            _title(context, article),

            /// learn more button
            if (showLearnMoreButton) _learnMoreButton(context),

            if (showBottomRoundContainer) _bottomRoundContainer(context)
          ],
        ),
      ),
    );
  }

  /// This is the tag for the news
  /// shows on top of the news title text
  Widget _tag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        localizations.news_of_the_day,
        style: AppStyles.caption.copyWith(color: Colors.white),
      ),
    );
  }

  /// This is the title of the news
  Widget _title(BuildContext context, Articles article) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        article.title ?? "",
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.headline5.copyWith(color: Colors.white),
      ),
    );
  }

  /// This is the learn more button
  Widget _learnMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: TextButton(
        onPressed: () {
          context.push(NewsDetailScreen(article: article));
        },
        child: Row(
          children: [
            Text(
              localizations.learn_more,
              style: AppStyles.bodyText1.copyWith(color: Colors.white),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomRoundContainer(BuildContext context) {
    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
    );
  }
}
