import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/gen/assets.gen.dart';
import 'package:news_app_flutter/src/app_controller.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/constants/app_constants.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_text_field.dart';
import 'package:news_app_flutter/src/ui_layer/common/sliver_delegates.dart';
import 'package:news_app_flutter/src/ui_layer/screens/global_search_screen.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

/// purpose - to show top headlines based on predefined categories
/// this screen will be shown when the user clicks on the discover tab
/// this screen contains a tab bar with 7 tabs
/// each tab will show the top headlines of the category
/// the categories are
/// general, business, entertainment, health, science, sports, technology
/// the user can also search for the news
class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab>
    with SingleTickerProviderStateMixin {
  /// bloc instance
  late DiscoverBloc _discoverBloc;

  /// tab controller to control the tabs
  late TabController _tabController;

  /// localizations
  late AppLocalizations _localizations;

  /// list of visited tabs to keep track of visited tabs
  /// to avoid calling the api again on the same tab click
  List<int> visitedTabs = [];

  /// to keep track of the active category
  String activeCategory = AppConstants.general;

  /// list of categories to show in the tab bar
  late List<Tab> totalCategories;

  /// page number for each category
  int pageGeneral = 1;
  int pageBusiness = 1;
  int pageEntertainment = 1;
  int pageHealth = 1;
  int pageScience = 1;
  int pageSports = 1;
  int pageTechnology = 1;

  /// list of articles for each category
  List<Articles> articlesGeneral = [];
  List<Articles> articlesBusiness = [];
  List<Articles> articlesEntertainment = [];
  List<Articles> articlesHealth = [];
  List<Articles> articlesScience = [];
  List<Articles> articlesSports = [];
  List<Articles> articlesTechnology = [];

  /// scroll controllers for every article's list
  ScrollController scrollControllerGeneral = ScrollController();
  ScrollController scrollControllerBusiness = ScrollController();
  ScrollController scrollControllerEntertainment = ScrollController();
  ScrollController scrollControllerHealth = ScrollController();
  ScrollController scrollControllerScience = ScrollController();
  ScrollController scrollControllerSports = ScrollController();
  ScrollController scrollControllerTechnology = ScrollController();

  /// text field controller
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    /// initialize the localizations
    _localizations = AppLocalizations.of(navigatorKey.currentContext!)!;

    /// initialize the list of categories
    totalCategories = [
      Tab(text: _localizations.general),
      Tab(text: _localizations.business),
      Tab(text: _localizations.entertainment),
      Tab(text: _localizations.health),
      Tab(text: _localizations.science),
      Tab(text: _localizations.sports),
      Tab(text: _localizations.technology),
    ];

    /// initialize the tab controller
    _tabController = TabController(length: totalCategories.length, vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      /// call the api to get the data for the first time
      _discoverBloc.add(
        DiscoverGetContentEvent(
          page: 1,
          category: AppConstants.general,
        ),
      );
    });

    /// listen for tab page changes
    addTabPageChangeListener();

    /// listen for scroll events
    addScrollListener();

    /// call super
    super.initState();
  }

  /// add listener to the tab controller
  /// to call the api when the tab is changed
  void addTabPageChangeListener() {
    _tabController.addListener(
      () {
        /// get the current index of the tab controller
        /// and call the api according to the index
        /// index - 0 -> general
        /// index - 1 -> business
        /// index - 2 -> entertainment
        /// index - 3 -> health
        /// index - 4 -> science
        /// index - 5 -> sports
        /// index - 6 -> technology

        /// get the category according to the index
        activeCategory =
            AppConstants.getDiscoverCategoryName(_tabController.index);

        /// explicitly add 0 to visited tabs
        visitedTabs.add(0);

        /// check if the visited tabs list contains the current index
        if (!visitedTabs.contains(_tabController.index)) {
          visitedTabs.add(_tabController.index);

          /// fire the event to get the data
          _discoverBloc.add(
            DiscoverGetContentEvent(
              page: 1,
              category: activeCategory,
            ),
          );
        }
      },
    );
  }

  /// below function will add the scroll listener to every scroll controller
  void addScrollListener() {
    scrollControllerGeneral.addListener(() {
      if (scrollControllerGeneral.position.pixels ==
          scrollControllerGeneral.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageGeneral,
            category: AppConstants.general,
          ),
        );
      }
    });
    scrollControllerBusiness.addListener(() {
      if (scrollControllerBusiness.position.pixels ==
          scrollControllerBusiness.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageBusiness,
            category: AppConstants.business,
          ),
        );
      }
    });
    scrollControllerEntertainment.addListener(() {
      if (scrollControllerEntertainment.position.pixels ==
          scrollControllerEntertainment.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageEntertainment,
            category: AppConstants.entertainment,
          ),
        );
      }
    });
    scrollControllerHealth.addListener(() {
      if (scrollControllerHealth.position.pixels ==
          scrollControllerHealth.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageHealth,
            category: AppConstants.health,
          ),
        );
      }
    });
    scrollControllerScience.addListener(() {
      if (scrollControllerScience.position.pixels ==
          scrollControllerScience.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageScience,
            category: AppConstants.science,
          ),
        );
      }
    });
    scrollControllerSports.addListener(() {
      if (scrollControllerSports.position.pixels ==
          scrollControllerSports.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageSports,
            category: AppConstants.sports,
          ),
        );
      }
    });
    scrollControllerTechnology.addListener(() {
      if (scrollControllerTechnology.position.pixels ==
          scrollControllerTechnology.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageTechnology,
            category: AppConstants.technology,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _discoverBloc = BlocProvider.of<DiscoverBloc>(context);
    return Scaffold(
      body: DefaultTabController(
        length: totalCategories.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              /// app bar
              /// contains the search text field
              _appBar(context),

              /// tab bar
              /// contains the tab bar with 7 tabs
              _tabPersistentHeader(context),
            ];
          },
          body: BlocBuilder<DiscoverBloc, DiscoverState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case DiscoverLoadingState:

                  /// show the loader
                  return Center(child: Assets.animations.searchAnim.lottie());
                case DiscoverFailureState:

                  /// build tab bar with empty list
                  /// this will show no data found animation
                  return _buildTabBarView("", []);
                case DiscoverSuccessState:

                  /// build tab bar with the data
                  DiscoverSuccessState stateData =
                      state as DiscoverSuccessState;
                  return _buildTabBarView(
                      stateData.category, stateData.articles);
                default:

                  /// show the loader by default
                  return Center(child: Assets.animations.searchAnim.lottie());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 240.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _localizations.discover,
                style: AppStyles.headline4,
              ),
              Text(
                _localizations.news_from_all_over_the_world,
                style: AppStyles.bodyText2,
              ),
              const SizedBox(height: 20),

              /// search text field
              CommonTextField(
                showPrefixIcon: true,
                showSuffixIcon: true,
                controller: searchController,
                onChanged: _handleTextFieldOnChanged,
                onSuffixIconPressed: _handleSearchFilterIconTap,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// tab bar with 7 tabs
  /// each tab will show the top headlines of the category
  Widget _tabPersistentHeader(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          tabAlignment: TabAlignment.start,
          tabs: totalCategories,
        ),
      ),
    );
  }

  /// tab bar view
  /// this will show the list of articles according to the category
  Widget _buildTabBarView(String category, List<Articles> articles) {
    /// add the articles to the respective list according to the category
    switch (category) {
      case AppConstants.general:
        articlesGeneral.addAll(articles);
        break;
      case AppConstants.business:
        articlesBusiness.addAll(articles);
        break;
      case AppConstants.entertainment:
        articlesEntertainment.addAll(articles);
        break;
      case AppConstants.health:
        articlesHealth.addAll(articles);
        break;
      case AppConstants.science:
        articlesScience.addAll(articles);
        break;
      case AppConstants.sports:
        articlesSports.addAll(articles);
        break;
      case AppConstants.technology:
        articlesTechnology.addAll(articles);
        break;
    }
    return TabBarView(
      controller: _tabController,
      children: [
        /// generate list view for general category
        _generateListView(scrollControllerGeneral, articlesGeneral, category),

        /// generate list view for business category
        _generateListView(scrollControllerBusiness, articlesBusiness, category),

        /// generate list view for entertainment category
        _generateListView(
            scrollControllerEntertainment, articlesEntertainment, category),

        /// generate list view for health category
        _generateListView(scrollControllerHealth, articlesHealth, category),

        /// generate list view for science category
        _generateListView(scrollControllerScience, articlesScience, category),

        /// generate list view for sports category
        _generateListView(scrollControllerSports, articlesSports, category),

        /// generate list view for technology category
        _generateListView(
            scrollControllerTechnology, articlesTechnology, category),
      ],
    );
  }

  Widget _generateListView(
      ScrollController controller, List<Articles> articles, String category) {
    /// check if the list is empty
    /// if empty show no data found
    if (articles.isEmpty) {
      return Assets.animations.noDataAnim.lottie(repeat: false, reverse: true);
    }

    /// if not empty show the list
    return RefreshIndicator(
      onRefresh: () async {
        triggerPullToRefresh(category);
      },
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: articles.length + 1,
        itemBuilder: (context, index) {
          /// show the loader at the end of the list
          if (index == articles.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
            );
          }

          /// build the list tile
          return _listTile(context, articles[index]);
        },
      ),
    );
  }

  /// list tile
  /// this will show the article details
  /// when the user clicks on the list tile
  Widget _listTile(BuildContext context, Articles article) {
    return ListTile(
      onTap: () {
        context.push(NewsDetailScreen(article: article));
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          article.urlToImage ?? "https://picsum.photos/200/300",
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        article.title ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.bodyText2.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          /// show the time in hours ago
          const Icon(Icons.access_time_outlined, size: 12),
          const SizedBox(width: 2),
          Text(
            DateTimeHelper.getHoursAgo(
              article.publishedAt.toString(),
            ),
            style: AppStyles.caption,
          ),

          /// empty space
          const SizedBox(width: 20),

          /// show the author name
          const Icon(Icons.person_outlined, size: 14),
          const SizedBox(width: 2),
          Text(
            "by ${article.source?.name ?? ""}",
            style: AppStyles.caption,
          ),
        ],
      ),
    );
  }

  void _handleTextFieldOnChanged(String value) {
    {
      switch (activeCategory) {
        case AppConstants.general:
          pageGeneral = 1;
          articlesGeneral = [];
          break;
        case AppConstants.business:
          pageBusiness = 1;
          articlesBusiness = [];
          break;
        case AppConstants.entertainment:
          pageEntertainment = 1;
          articlesEntertainment = [];
          break;
        case AppConstants.health:
          pageHealth = 1;
          articlesHealth = [];
          break;
        case AppConstants.science:
          pageScience = 1;
          articlesScience = [];
          break;
        case AppConstants.sports:
          pageSports = 1;
          articlesSports = [];
          break;
        case AppConstants.technology:
          pageTechnology = 1;
          articlesTechnology = [];
          break;
      }

      /// fire event to get the data
      _discoverBloc.add(
        DiscoverGetContentEvent(
          page: 1,
          category: activeCategory,
          searchTerm: value,
        ),
      );
    }
  }

  void _handleSearchFilterIconTap() {
    debugPrint("Search filter icon tapped");
    context.push(GlobalSearchScreen(
      searchTerm: searchController.text.trim().toString(),
    ));
  }

  /// this function will trigger the pull to refresh
  void triggerPullToRefresh(String category) {
    switch (_tabController.index) {
      case 0:
        pageGeneral = 1;
        articlesGeneral.clear();
        break;
      case 1:
        pageBusiness = 1;
        articlesBusiness.clear();
        break;
      case 2:
        pageEntertainment = 1;
        articlesEntertainment.clear();
        break;
      case 3:
        pageHealth = 1;
        articlesHealth.clear();
        break;
      case 4:
        pageScience = 1;
        articlesScience.clear();
        break;
      case 5:
        pageSports = 1;
        articlesSports.clear();
        break;
      case 6:
        pageTechnology = 1;
        articlesTechnology.clear();
        break;
    }
    _discoverBloc.add(
      DiscoverGetContentEvent(
          page: 1,
          category: category,
          searchTerm: searchController.text.trim().toString()),
    );
  }
}
