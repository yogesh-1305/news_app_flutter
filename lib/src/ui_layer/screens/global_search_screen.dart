import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_app_flutter/gen/assets.gen.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_bloc.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_event.dart';
import 'package:news_app_flutter/src/business_layer/bloc/global_search/global_search_state.dart';
import 'package:news_app_flutter/src/business_layer/utils/dialog_util.dart';
import 'package:news_app_flutter/src/business_layer/utils/extensions/context_extension.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_image_widget.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_text_field.dart';
import 'package:news_app_flutter/src/ui_layer/screens/news_detail_screen.dart';

/// This is the global search screen
/// purpose - to show the search results from all over the world
/// user can search for news and add filters also
class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({
    super.key,
    this.searchTerm = "",
  });

  /// search term
  /// this is the search term entered by the user
  /// from the discover tab
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

  late AppLocalizations _localizations;

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
      /// add the initial event to the bloc
      _globalSearchBloc.add(
          GlobalSearchEventDoSearch(searchTerm: widget.searchTerm, page: page));
    });

    /// add scroll listener for pagination
    addScrollListener();

    super.initState();
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        /// call the api with the next page number
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
    /// Initialize the localizations
    _localizations = AppLocalizations.of(context)!;

    /// Initialize the bloc
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
                child: Text(_localizations.applied_filters_colon,
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
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case GlobalSearchInitialState:

            /// initial view - show animation and text
            return _initialView();
          case GlobalSearchLoading:

            /// show loading animation
            return Center(child: Assets.animations.searchAnim.lottie());
          case GlobalSearchSuccess:

            /// show news items list
            List<Articles> articles = (state as GlobalSearchSuccess).articles;
            return _newsItemsListView(articles);
          case GlobalSearchFailure:

            /// show error animation
            return Expanded(
                child: Center(child: Assets.animations.noDataAnim.lottie()));
          default:

            /// show loading animation
            return Center(child: Assets.animations.searchAnim.lottie());
        }
      },
    );
  }

  /// initial view of the screen
  /// shows an animation and a text
  /// this is done because news-api does not allow to search without a search term
  Widget _initialView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Assets.animations.phoneGlobeAnim.lottie()),
          const SizedBox(height: 20),
          Text(
            _localizations.search_for_news_from_all_over_the_world,
            style: AppStyles.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _newsItemsListView(List<Articles> articles) {
    return Expanded(
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
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
            child: _newsGridItem(articles[index]),
          );
        },
      ),
    );
  }

  /// news grid item
  /// shows the news image, title, description, author and published date
  Widget _newsGridItem(Articles article) {
    return Card(
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            CommonImageWidget(
              url: article.urlToImage,
              width: double.infinity,
              height: 100,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// title
                  Text(
                    article.title ?? "N/A",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.headline6,
                  ),
                  const SizedBox(height: 4),

                  /// description
                  Text(
                    article.description ?? "N/A",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.caption,
                  ),
                  const SizedBox(height: 4),

                  /// published date
                  Text(
                    DateTimeHelper.getHoursAgo(article.publishedAt ?? "N/A"),
                    style: AppStyles.caption,
                  ),
                  const SizedBox(height: 4),

                  /// author
                  Text(
                    "By ${article.author ?? "Unknown"}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppStyles.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// filters drawer
  /// shows the filters drawer when the filter button is clicked
  /// this drawer is shown on the right side of the screen
  /// this drawer contains the sort by list and date filters
  /// when the user applies filters, the search is done with the filters
  /// when the user clears all filters, the search is done without any filters
  Widget _buildFiltersDrawer() {
    return BlocBuilder<GlobalSearchBloc, GlobalSearchState>(
        buildWhen: (previous, current) {
      return current is GlobalSearchFilterState;
    }, builder: (context, state) {
      if (state.runtimeType == GlobalSearchFilterState) {
        /// show the drawer when the state is GlobalSearchFilterState
        return _endDrawerWidget(state as GlobalSearchFilterState);
      } else {
        /// hide the drawer when the state is not GlobalSearchFilterState
        return const SizedBox();
      }
    });
  }

  Widget _endDrawerWidget(GlobalSearchFilterState state) {
    return Drawer(
      child: SafeArea(
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
          child: Text(
            _localizations.clear_all,
            style: const TextStyle(
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
          child: Text(
            _localizations.apply,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// sort by list
  /// contains the list of sort by options
  /// when the user selects an option, the search is done with the selected option
  /// options are Relevance, Popularity and Published At
  List<Widget> _buildSortByList(GlobalSearchFilterState state) {
    int sortIndex = -1;
    switch (state.sortBy?.toLowerCase()) {
      case "relevancy":
        sortIndex = 0;
        break;
      case "popularity":
        sortIndex = 1;
        break;
      case "publishedat":
        sortIndex = 2;
        break;
      default:
        sortIndex = -1;
    }
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(_localizations.sort_by, style: AppStyles.bodyText1),
      ),
      const SizedBox(height: 10),

      /// relevancy
      _sortByListTile(state, _localizations.relevancy,
          _localizations.relevancy_desc, 0, sortIndex),

      /// popularity
      _sortByListTile(state, _localizations.popularity,
          _localizations.popularity_desc, 1, sortIndex),

      /// published at
      _sortByListTile(state, _localizations.publishedAt,
          _localizations.publishedAt_desc, 2, sortIndex),
    ];
  }

  Widget _sortByListTile(GlobalSearchFilterState state, String title,
      String desc, int index, int selectedIndex) {
    String sortBy = "";
    switch (index) {
      case 0:
        sortBy = "relevancy";
        break;
      case 1:
        sortBy = "popularity";
        break;
      case 2:
        sortBy = "publishedat";
        break;
      default:
        sortBy = "";
    }
    return ListTile(
      horizontalTitleGap: 10,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      onTap: () {
        editFilter(sortBy, state.fromDate, state.toDate);
      },
      leading: Radio<int>(
        value: selectedIndex,
        groupValue: index,
        onChanged: (int? value) {
          editFilter(sortBy, state.fromDate, state.toDate);
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
        child: Text(_localizations.filter_by_date, style: AppStyles.bodyText1),
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
                  Text(_localizations.from, style: AppStyles.caption),
                  ElevatedButton(
                    onPressed: () async {
                      (String?, String?) selectedDate =
                          await DialogUtil.showDatePickerDialog(context);
                      if (selectedDate.$1 != null && selectedDate.$2 != null) {
                        editFilter(state.sortBy, selectedDate.$1, state.toDate);
                      }
                    },
                    child: Text(state.fromDate ?? _localizations.select_date),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_localizations.to_colon, style: AppStyles.caption),
                  ElevatedButton(
                    onPressed: () async {
                      (String?, String?) selectedDate =
                          await DialogUtil.showDatePickerDialog(context);
                      if (selectedDate.$1 != null && selectedDate.$2 != null) {
                        editFilter(
                            state.sortBy, state.fromDate, selectedDate.$1);
                      }
                    },
                    child: Text(state.toDate ?? _localizations.select_date),
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
    _globalSearchBloc.add(
      GlobalSearchEditFilterEvent(
        sortBy: sortBy,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
  }
}
