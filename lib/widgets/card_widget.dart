import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/models/restaurant.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/utils/config.dart';
import 'package:restaurant/widgets/skeleton_widget.dart';

class CardWidget extends StatelessWidget {
  final Restaurant restaurant;

  final Function() ontap;

  const CardWidget({
    Key? key,
    required this.restaurant,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
          future: provider.isFavorite(restaurant.id),
          builder: (context, snapshot) {
            var isFavorite = snapshot.data ?? false;
            return InkWell(
              onTap: ontap,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Hero(
                          tag: Config.IMG_SMALL_URL + restaurant.pictureId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  Config.IMG_SMALL_URL + restaurant.pictureId,
                              placeholder: (context, url) {
                                return const Skeleton(height: 70);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.location_on,
                                      size: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "  ${restaurant.city}",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
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
                                      size: 14,
                                      color: Colors.yellow[900],
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  ${restaurant.rating}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: isFavorite
                          ? IconButton(
                              onPressed: () {
                                provider.removeFavorite(restaurant.id);
                              },
                              icon: const Icon(Icons.bookmark),
                            )
                          : IconButton(
                              onPressed: () {
                                provider.addFavoriteRestaurant(restaurant);
                              },
                              icon: const Icon(Icons.bookmark_border),
                            ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            );
          });
    });
  }
}
