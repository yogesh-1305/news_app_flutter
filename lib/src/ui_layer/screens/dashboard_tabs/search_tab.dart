import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_text_field.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 7,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
            body: TabBarView(
              controller: _tabController,
              children: [
                _itemsListView(),
                _itemsListView(),
                _itemsListView(),
                _itemsListView(),
                _itemsListView(),
                _itemsListView(),
                _itemsListView(),
              ],
            )),
      ),
    );
  }

  Widget _itemsListView() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          isThreeLine: true,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://picsum.photos/200/300",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: const Text(
            "Title",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Row(
            children: [
              Icon(Icons.access_time_outlined, size: 15),
              SizedBox(width: 5),
              Text("4 hours ago"),
            ],
          ),
        );
      },
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
