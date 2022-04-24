import 'package:flutter/cupertino.dart';
import 'package:restaurant/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getSuggetsRestaurantPreferences();
  }

  bool _isDailyNewsActive = false;
  bool get isDailyNewsActive => _isDailyNewsActive;

  void _getSuggetsRestaurantPreferences() async {
    _isDailyNewsActive = await preferencesHelper.isDailyNewsActive;
    notifyListeners();
  }

  void enableSuggets(bool value) {
    preferencesHelper.setDailyNews(value);
    _getSuggetsRestaurantPreferences();
  }
}
