import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/home/home_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';
import 'package:news_app_flutter/src/data_layer/res/app_colors.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late AppLocalizations _localizations;

  late HomeBloc _homeBloc;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
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
    return BlocBuilder<HomeBloc, HomeState>(buildWhen: (previous, current) {
      return current is HomeInitial ||
          current is HomeLoadingState ||
          current is HomeSuccessState ||
          current is HomeFailureState;
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case HomeInitial:
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        case HomeLoadingState:
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        case HomeSuccessState:
          final data = (state as HomeSuccessState).response;
          return _buildSuccessScreen(context, data.articles ?? []);
        case HomeFailureState:
          return Center(child: Text("Error", style: AppStyles.headline5));
        default:
          return Center(child: Text("Error", style: AppStyles.headline5));
      }
    });
  }

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
            _buildNewsOfTheDay(context, data.first),
            _buildHorizontalListSection(
                context, "Breaking News", data.sublist(1)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsOfTheDay(BuildContext context, Articles article) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          Image.network(
            article.urlToImage ?? "",
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.45,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.stackShadowGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "News of the Day",
                      style: AppStyles.caption.copyWith(color: Colors.white),
                    ),
                  ),
                  Text(
                    article.title ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.headline5.copyWith(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(NewsDetailScreen(article: article));
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Learn More",
                          style:
                              AppStyles.bodyText1.copyWith(color: Colors.white),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                onPressed: () {},
                child: Text(
                  "View All",
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
          Text(
            data.title ?? "",
            style: AppStyles.headline6,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            DateTimeHelper.getHoursAgo(data.publishedAt ?? ""),
            style: AppStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
