import 'package:flutter/cupertino.dart';
import 'package:restaurant/data/db/database_helper.dart';
import 'package:restaurant/data/models/restaurant.dart';
import 'package:restaurant/utils/state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;
  DatabaseProvider({required this.databaseHelper}) {
    _getFavoriteRestaurants();
  }

  late ResultState _state;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Restaurant> _favoriteRestaurants = [];

  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;

  void _getFavoriteRestaurants() async {
    _favoriteRestaurants = await databaseHelper.getFavoriteRestaurant();
    if (_favoriteRestaurants.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }

    notifyListeners();
  }

  void addFavoriteRestaurant(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavoriteRestaurant(restaurant);
      _getFavoriteRestaurants();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final restaurant = await databaseHelper.getFavoriteRestaurantById(id);
    return restaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavoriteRestaurants();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
