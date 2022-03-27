import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/common.dart';
import 'package:restaurant/provider/app_provider.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/utils/config.dart';
import 'package:restaurant/widgets/card_widget.dart';
import 'package:restaurant/widgets/shimmer_card_widget.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var isClearTextVisible = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.onSearch("%20");
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchBar(context, provider),
            body(context),
          ],
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context, AppProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            if (value.isNotEmpty) {
              isClearTextVisible = true;
            } else {
              isClearTextVisible = false;
            }
          });
          if (value.length >= 3) {
            var query = value.trim().replaceAll(" ", "%20");
            provider.onSearch(query);
          } else if (value.isEmpty) {
            provider.onSearch("%20");
          }
        },
        decoration: InputDecoration(
          isDense: true,
          hintText: AppLocalizations.of(context)!.searchHint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          suffixIcon: Visibility(
            child: IconButton(
              onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
                isClearTextVisible = false;
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
            visible: isClearTextVisible,
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.HasSearchData) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.searchResult.restaurants.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  imageUrl: Config.IMG_SMALL_URL +
                      state.searchResult.restaurants[index].pictureId,
                  restaurantName: state.searchResult.restaurants[index].name,
                  country: state.searchResult.restaurants[index].city,
                  rating:
                      state.searchResult.restaurants[index].rating.toString(),
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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const ShimmerCard();
              },
              itemCount: 12,
            ),
          );
        } else if (state.state == ResultState.Error) {
          return const Center(
            child: Text("No internet please connect to the internet"),
          );
        } else {
          return const Center(
            child: Text("No Data"),
          );
        }
      },
    );
  }
}
