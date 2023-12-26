import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_flutter/gen/assets.gen.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/dialog_util.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_text_field.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({
    super.key,
    this.searchTerm = "",
  });

  final String searchTerm;

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  /// scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// controller for search text field
  final TextEditingController _searchController = TextEditingController();

  /// list of applied filters in the search
  List<String> appliedFilters = [];

  /// global search bloc
  late GlobalSearchBloc _globalSearchBloc;

  /// filter variables
  String? sortBy;
  String? fromDate;
  String? toDate;

  /// page number for pagination
  int page = 1;

  /// scroll controller for pagination
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _searchController.text = widget.searchTerm;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _globalSearchBloc.add(
          GlobalSearchEventDoSearch(searchTerm: widget.searchTerm, page: page));
    });

    addScrollListener();

    super.initState();
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _globalSearchBloc.add(GlobalSearchEventDoSearch(
            page: ++page,
            searchTerm: _searchController.text,
            sortBy: sortBy,
            fromDate: fromDate,
            toDate: toDate));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _globalSearchBloc = BlocProvider.of<GlobalSearchBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      endDrawer: _buildFiltersDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: CommonTextField(
        fillColor: Colors.transparent,
        controller: _searchController,
        onChanged: (String value) {
          _globalSearchBloc.add(GlobalSearchEventDoSearch(
              page: 1,
              searchTerm: value,
              sortBy: sortBy,
              fromDate: fromDate,
              toDate: toDate));
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            _globalSearchBloc.add(GlobalSearchEditFilterEvent(
              searchTerm: _searchController.text,
              sortBy: sortBy,
              fromDate: fromDate,
              toDate: toDate,
            ));
            _scaffoldKey.currentState!.openEndDrawer();
          },
          icon: const Icon(Icons.filter_alt_outlined),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _appliedFiltersList(),
        _newsItemsList(),
      ],
    );
  }

  Widget _appliedFiltersList() {
    return BlocBuilder<GlobalSearchBloc, GlobalSearchState>(
        buildWhen: (previous, current) {
      return current is GlobalSearchSuccess;
    }, builder: (context, state) {
      if (state is GlobalSearchSuccess) {
        final data = state.appliedFilters;
        if (data.isEmpty) {
          return const SizedBox();
        }
        return SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Applied Filters:",
                    style: AppStyles.caption
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                  itemBuilder: (context, index) {
                    return Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      label: Text(
                        data[index],
                        style: AppStyles.caption.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _newsItemsList() {
    return BlocBuilder<GlobalSearchBloc, GlobalSearchState>(
        buildWhen: (previous, current) {
      return current is! GlobalSearchFilterState;
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case GlobalSearchInitialState:
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.animations.phoneGlobeAnim.lottie(),
                const SizedBox(height: 20),
                Text(
                  "Search for news from all over the world.",
                  style: AppStyles.headline6,
                ),
              ],
            ),
          );
        case GlobalSearchLoading:
          return Center(
            child: Assets.animations.searchAnim.lottie(),
          );
        case GlobalSearchSuccess:
          List<Articles> articles = (state as GlobalSearchSuccess).articles;
          return _newsItemsListView(articles);
        case GlobalSearchFailure:
          return Center(
            child: Text(
              (state as GlobalSearchFailure).exceptionMessage,
              style: AppStyles.bodyText1,
            ),
          );
        default:
          return const SizedBox();
      }
    });
  }

  Widget _newsItemsListView(List<Articles> articles) {
    return Expanded(
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: articles.length + 1,
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return GestureDetector(
            onTap: () {
              /// open news details screen
              context.push(
                NewsDetailScreen(
                  article: articles[index],
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Image.network(
                      articles[index].urlToImage ??
                          "https://picsum.photos/300/200",
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articles[index].title ?? "News Title",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.headline6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            articles[index].description ?? "News Description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateTimeHelper.getHoursAgo(
                                articles[index].publishedAt ?? "2021-09-01"),
                            style: AppStyles.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "By ${articles[index].author ?? "Unknown"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.caption
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersDrawer() {
    return BlocBuilder<GlobalSearchBloc, GlobalSearchState>(
        buildWhen: (previous, current) {
      if (current is GlobalSearchFilterState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state.runtimeType == GlobalSearchFilterState) {
        return _endDrawerWidget(state as GlobalSearchFilterState);
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _endDrawerWidget(GlobalSearchFilterState state) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// empty space
          const SizedBox(height: 30),

          /// drawer header buttons
          _drawerHeaderButtons(state),

          /// horizontal divider
          const Divider(),

          /// sort by list
          ..._buildSortByList(state),

          /// empty space
          const SizedBox(height: 10),

          /// date filters
          ..._dateFilters(state),
        ],
      ),
    );
  }

  Widget _drawerHeaderButtons(GlobalSearchFilterState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            /// clear all filters
            sortBy = null;
            fromDate = null;
            toDate = null;
            _globalSearchBloc.add(GlobalSearchEventDoSearch(
                page: 1, searchTerm: _searchController.text));

            /// close the drawer
            _scaffoldKey.currentState!.closeEndDrawer();
          },
          child: const Text(
            "Clear All",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            String fromDate = DateTimeHelper.convertDateFormat(
                inputDate: state.fromDate ?? "");
            String toDate =
                DateTimeHelper.convertDateFormat(inputDate: state.toDate ?? "");

            /// get filters globally
            sortBy = state.sortBy;
            this.fromDate = state.fromDate;
            this.toDate = state.toDate;

            /// apply filters and do search
            _globalSearchBloc.add(GlobalSearchEventDoSearch(
                page: 1,
                searchTerm: _searchController.text,
                sortBy: state.sortBy,
                fromDate: fromDate,
                toDate: toDate));
            _scaffoldKey.currentState!.closeEndDrawer();
          },
          child: const Text(
            "Apply",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSortByList(GlobalSearchFilterState state) {
    int sortIndex = -1;
    switch (state.sortBy) {
      case "Relevance":
        sortIndex = 0;
        break;
      case "Popularity":
        sortIndex = 1;
        break;
      case "Published At":
        sortIndex = 2;
        break;
      default:
        sortIndex = -1;
    }
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text("Sort by:", style: AppStyles.bodyText1),
      ),
      const SizedBox(height: 10),
      _sortByListTile(state, "Relevance", "Sort by relevance", 0, sortIndex),
      _sortByListTile(state, "Popularity", "Sort by popularity", 1, sortIndex),
      _sortByListTile(
          state, "Published At", "Sort by published date", 2, sortIndex),
    ];
  }

  Widget _sortByListTile(GlobalSearchFilterState state, String title,
      String desc, int index, int selectedIndex) {
    return ListTile(
      horizontalTitleGap: 10,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      onTap: () {
        editFilter(title, state.fromDate, state.toDate);
      },
      leading: Radio<int>(
        value: selectedIndex,
        groupValue: index,
        onChanged: (int? value) {
          editFilter(title, state.fromDate, state.toDate);
        },
      ),
      title: Text(
        title,
        style: AppStyles.headline6,
      ),
      subtitle: Text(
        desc,
        style: AppStyles.caption,
      ),
    );
  }

  List<Widget> _dateFilters(GlobalSearchFilterState state) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text("Filter by date:", style: AppStyles.bodyText1),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From:", style: AppStyles.caption),
                  ElevatedButton(
                    onPressed: () async {
                      (String?, String?) selectedDate =
                          await DialogUtil.showDatePickerDialog(context);
                      if (selectedDate.$1 != null && selectedDate.$2 != null) {
                        editFilter(state.sortBy, selectedDate.$1, state.toDate);
                      }
                    },
                    child: Text(state.fromDate ?? "Select Date"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("To:", style: AppStyles.caption),
                  ElevatedButton(
                    onPressed: () async {
                      (String?, String?) selectedDate =
                          await DialogUtil.showDatePickerDialog(context);
                      if (selectedDate.$1 != null && selectedDate.$2 != null) {
                        editFilter(
                            state.sortBy, state.fromDate, selectedDate.$1);
                      }
                    },
                    child: Text(state.toDate ?? "Select Date"),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  void editFilter(String? sortBy, String? fromDate, String? toDate) {
    _globalSearchBloc.add(GlobalSearchEditFilterEvent(
      sortBy: sortBy,
      fromDate: fromDate,
      toDate: toDate,
    ));
  }
}