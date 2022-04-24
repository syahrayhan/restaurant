import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/style.dart';
import 'package:restaurant/provider/preferences_provider.dart';
import 'package:restaurant/provider/scheduling_restaurant_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (context, provider, child) {
      return ListView(
        children: [
          Material(
            child: ListTile(
              title: const Text('Restaurant Notifications'),
              trailing: Consumer<SchedulingRestaurantProvider>(
                  builder: (context, suggest, _) {
                return Switch.adaptive(
                  value: provider.isDailyNewsActive,
                  onChanged: (value) async {
                    suggest.suggestRestaurant(value);
                    provider.enableSuggets(value);
                  },
                  activeColor: primaryColor,
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: _buildBody(context),
    );
  }
}
