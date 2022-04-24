import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/widgets/card_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.favoriteRestaurants.length,
          itemBuilder: (context, index) {
            return CardWidget(
              restaurant: provider.favoriteRestaurants[index],
              ontap: () {
                Navigation.intentWithData(
                  DetailPage.routeName,
                  DetailPage(
                    restaurantId: provider.favoriteRestaurants[index].id,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: _buildBody(context),
    );
  }
}
