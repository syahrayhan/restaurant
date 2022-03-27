import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/common.dart';
import 'package:restaurant/provider/app_provider.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/ui/search_page.dart';
import 'package:restaurant/utils/config.dart';
import 'package:restaurant/widgets/card_widget.dart';
import 'package:restaurant/widgets/shimmer_card_widget.dart';

class MenuListPage extends StatefulWidget {
  static const routeName = '/menu_list_page';

  const MenuListPage({Key? key}) : super(key: key);

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    Future.microtask(() {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.getRestaurants();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, SearchPage.routeName);
              provider.getRestaurants();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(context),
            const SizedBox(height: 15),
            body(context),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.menuSubtitle,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget body(BuildContext context) {
    return Expanded(
      child: Consumer<AppProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.HasData) {
            return RefreshIndicator(
              key: keyRefresh,
              onRefresh: () async {
                state.getRestaurants();
              },
              child: ListView.builder(
                itemCount: state.restaurants.restaurants.length,
                itemBuilder: (context, index) {
                  return CardWidget(
                    imageUrl: Config.IMG_SMALL_URL +
                        state.restaurants.restaurants[index].pictureId,
                    restaurantName: state.restaurants.restaurants[index].name,
                    country: state.restaurants.restaurants[index].city,
                    rating: "${state.restaurants.restaurants[index].rating}",
                    ontap: () {
                      Navigator.pushNamed(context, DetailPage.routeName,
                          arguments: DetailPage(
                              restaurantId:
                                  state.restaurants.restaurants[index].id));
                    },
                  );
                },
              ),
            );
          } else if (state.state == ResultState.Loading) {
            return RefreshIndicator(
              key: keyRefresh,
              onRefresh: () async {
                state.getRestaurants();
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return const ShimmerCard();
                },
                itemCount: 12,
              ),
            );
          } else if (state.state == ResultState.Error) {
            return RefreshIndicator(
              key: keyRefresh,
              onRefresh: () async {
                state.getRestaurants();
              },
              child: Stack(
                children: [
                  ListView(),
                  const Center(
                    child: Text("No internet please refresh page"),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              key: keyRefresh,
              onRefresh: () async {
                state.getRestaurants();
              },
              child: Stack(
                children: [
                  ListView(),
                  const Center(
                    child: Text("No Data"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
