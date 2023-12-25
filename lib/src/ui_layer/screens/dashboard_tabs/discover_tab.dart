import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/discover/discover_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_text_field.dart';

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

  /// list of visited tabs to keep track of visited tabs
  /// to avoid calling the api again on the same tab click
  List<int> visitedTabs = [];

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

  @override
  void initState() {
    /// initialize the tab controller
    _tabController = TabController(length: 7, vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      /// call the api to get the data for the first time
      _discoverBloc.add(DiscoverGetContentEvent(page: 1, category: "general"));
    });

    addTabPageChangeListener();

    addScrollListener();

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

        visitedTabs.add(0); // explicitly add 0 to visited tabs
        if (!visitedTabs.contains(_tabController.index)) {
          visitedTabs.add(_tabController.index);

          String category = "general";

          /// get the category according to the index
          switch (_tabController.index) {
            case 0:
              category = "general";
              break;
            case 1:
              category = "business";
              break;
            case 2:
              category = "entertainment";
              break;
            case 3:
              category = "health";
              break;
            case 4:
              category = "science";
              break;
            case 5:
              category = "sports";
              break;
            case 6:
              category = "technology";
              break;
          }

          /// fire the event to get the data
          _discoverBloc.add(
            DiscoverGetContentEvent(
              page: 1,
              category: category,
            ),
          );
        }
      },
    );
  }

  void addScrollListener() {
    scrollControllerGeneral.addListener(() {
      if (scrollControllerGeneral.position.pixels ==
          scrollControllerGeneral.position.maxScrollExtent) {
        _discoverBloc.add(
          DiscoverGetContentEvent(
            page: ++pageGeneral,
            category: "general",
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
            category: "business",
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
            category: "entertainment",
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
            category: "health",
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
            category: "science",
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
            category: "sports",
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
            category: "technology",
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
        length: 7,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 240.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Discover",
                        style: AppStyles.headline4,
                      ),
                      Text(
                        "News from all over the world",
                        style: AppStyles.bodyText2,
                      ),
                      const SizedBox(height: 20),
                      const CommonTextField(),
                      const SizedBox(height: 10),
                    ],
                  ),
                )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.start,
                    tabs: const [
                      Tab(text: "General"),
                      Tab(text: "Business"),
                      Tab(text: "Entertainment"),
                      Tab(text: "Health"),
                      Tab(text: "Science"),
                      Tab(text: "Sports"),
                      Tab(text: "Technology"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: BlocBuilder<DiscoverBloc, DiscoverState>(
              builder: (context, state) {
            switch (state.runtimeType) {
              case DiscoverLoadingState:
                return const Center(child: CircularProgressIndicator());
              case DiscoverFailureState:
                return _buildTabBarView("", []);
              case DiscoverSuccessState:
                DiscoverSuccessState stateData = state as DiscoverSuccessState;
                return _buildTabBarView(stateData.category, stateData.articles);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  Widget _buildTabBarView(String category, List<Articles> articles) {
    switch (category) {
      case "general":
        articlesGeneral.addAll(articles);
        break;
      case "business":
        articlesBusiness.addAll(articles);
        break;
      case "entertainment":
        articlesEntertainment.addAll(articles);
        break;
      case "health":
        articlesHealth.addAll(articles);
        break;
      case "science":
        articlesScience.addAll(articles);
        break;
      case "sports":
        articlesSports.addAll(articles);
        break;
      case "technology":
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
      return Center(
          child: Text(
        "No data found",
        style: AppStyles.bodyText2,
      ));
    }

    /// if not empty show the list
    return RefreshIndicator(
      onRefresh: () async {
        triggerPullToRefresh(category);
      },
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                articles[index].urlToImage ?? "https://picsum.photos/200/300",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              articles[index].title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.access_time_outlined, size: 15),
                const SizedBox(width: 5),
                Text(DateTimeHelper.getHoursAgo(
                    articles[index].publishedAt.toString())),
              ],
            ),
          );
        },
      ),
    );
  }

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
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
