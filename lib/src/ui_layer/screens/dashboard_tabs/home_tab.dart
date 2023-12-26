import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/gen/assets.gen.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_news_header.dart';
import 'package:news_app_flutter/src/ui_layer/screens/global_search_screen.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

/// This is the home tab
/// purpose - to show the top headlines
/// this tab will be shown as the first tab in the dashboard screen
/// contains a top news of the day and a horizontal list of news
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  /// localizations object
  late AppLocalizations _localizations;

  /// home bloc
  late HomeBloc _homeBloc;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      /// add the initial event to the bloc
      /// this calls the api to get the top headlines
      _homeBloc.add(HomeInitialEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialize the localizations
    _localizations = AppLocalizations.of(context)!;

    /// Initialize the bloc
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    /// Return the BaseWidget
    return BaseWidget(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      /// Check the state of the bloc
      switch (state.runtimeType) {
        case HomeLoadingState:

          /// Show the loading animation
          return Center(child: Assets.animations.searchAnim.lottie());
        case HomeSuccessState:

          /// Show the success screen
          final data = (state as HomeSuccessState).response;
          return _buildSuccessScreen(context, data.articles ?? []);
        case HomeFailureState:

          /// Show the error screen
          return Center(child: Assets.animations.noDataAnim.lottie());
        default:

          /// Show the loading animation
          return Center(child: Assets.animations.noDataAnim.lottie());
      }
    });
  }

  /// This is the success screen
  Widget _buildSuccessScreen(BuildContext context, List<Articles> data) {
    return RefreshIndicator(
      onRefresh: () async {
        _homeBloc.add(HomeInitialEvent());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// This is the top news of the day
            CommonNewsHeader(
              localizations: _localizations,
              article: data.first,
              showNewsOfTheDayTag: true,
            ),

            /// This is the horizontal list view
            _buildHorizontalListSection(
                context, _localizations.breaking_news, data.sublist(1)),

            /// empty space
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// horizontal list widget,
  /// contains, header row (title, view all button)
  /// and the list view
  Widget _buildHorizontalListSection(
      BuildContext context, String title, List<Articles> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppStyles.headline5,
              ),
              TextButton(
                onPressed: () {
                  context.push(const GlobalSearchScreen());
                },
                child: Text(
                  _localizations.view_all,
                  style: AppStyles.bodyText1.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        /// This is the horizontal list view
        _listView(data),
      ],
    );
  }

  Widget _listView(List<Articles> data) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: data.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push(NewsDetailScreen(article: data[index]));
            },
            child: _horizontalListItem(data[index]),
          );
        },
      ),
    );
  }

  Widget _horizontalListItem(Articles data) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// image
          SizedBox(
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data.urlToImage ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// title
          Text(
            data.title ?? "",
            style: AppStyles.headline6,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),

          /// date published
          Text(
            DateTimeHelper.getHoursAgo(data.publishedAt ?? ""),
            style: AppStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          /// author
          Text(
            "by ${data.source?.name ?? ""}",
            style: AppStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
