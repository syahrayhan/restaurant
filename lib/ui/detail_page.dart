import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/common.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/provider/app_provider.dart';
import 'package:restaurant/utils/config.dart';
import 'package:restaurant/utils/state.dart';
import 'package:restaurant/widgets/menu_card_widget.dart';
import 'package:http/http.dart' as http;

import 'package:restaurant/widgets/skeleton_widget.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;

  const DetailPage({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();

  static const routeName = '/detail_page';
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    AppProvider provider;
    return ChangeNotifierProvider(
      create: (_) {
        provider = AppProvider(apiService: ApiService(http.Client()));
        return provider.getRestaurant(widget.restaurantId);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<AppProvider>(builder: (context, provider, _) {
            if (provider.state == ResultState.HasData) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageView(provider),
                    title(provider),
                    const SizedBox(height: 15),
                    description(provider),
                    const SizedBox(height: 15),
                    foods(provider),
                    const SizedBox(height: 15),
                    drinks(provider),
                  ],
                ),
              );
            } else if (provider.state == ResultState.Loading) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Skeleton(height: 200),
                    SizedBox(height: 30),
                    Skeleton(height: 40, width: 150),
                    SizedBox(height: 16),
                    Skeleton(height: 320),
                    SizedBox(height: 15),
                    Skeleton(height: 40, width: 150),
                    SizedBox(height: 15),
                    Skeleton(height: 200),
                  ],
                ),
              );
            } else {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 300),
                    Center(
                      child: Text("No internet please connect to the internet"),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget imageView(AppProvider provider) {
    return Hero(
      tag: provider.restaurant.restaurant.id,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: CachedNetworkImage(
          imageUrl:
              Config.IMG_LARGE_URL + provider.restaurant.restaurant.pictureId,
          imageBuilder: (context, imageProvider) => Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          placeholder: (context, url) {
            return const Skeleton(height: 100);
          },
        ),
      ),
    );
  }

  Widget title(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.restaurant.restaurant.name,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.location_on,
                    size: 18,
                  ),
                ),
                TextSpan(
                  text: "  ${provider.restaurant.restaurant.city}",
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.yellow[900],
                  ),
                ),
                TextSpan(
                    text: "  ${provider.restaurant.restaurant.rating}",
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget description(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Text(
        provider.restaurant.restaurant.description,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget foods(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.foodTitle,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: provider.restaurant.restaurant.menus.foods.length,
            itemBuilder: (context, index) {
              return MenuCard(
                imageUrl: 'assets/icons/ic_launcher.png',
                menuName:
                    provider.restaurant.restaurant.menus.foods[index].name,
                price: "10.000",
                rating: "4.5",
                ontap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget drinks(AppProvider provider) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.drinkTitle,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: provider.restaurant.restaurant.menus.drinks.length,
            itemBuilder: (context, index) {
              return MenuCard(
                imageUrl: 'assets/icons/drink.jpg',
                menuName:
                    provider.restaurant.restaurant.menus.drinks[index].name,
                price: "8.000",
                rating: "4.5",
                ontap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
