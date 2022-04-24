import 'package:flutter/cupertino.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/models/restaurant_detail_response.dart';
import 'package:restaurant/data/models/restaurant_response.dart';
import 'package:restaurant/data/models/search_restaurant_response.dart';
import 'package:restaurant/utils/state.dart';

class AppProvider extends ChangeNotifier {
  late ApiService apiService;

  AppProvider({required this.apiService});

  late RestaurantResponse _responseRestaurant;
  late SearchRestaurantResponse _responseSearchRestaurant;
  late RestaurantDetailModel _responseRestaurantDetail;

  ResultState _state = ResultState.Empty;

  late String _message;
  late String _query;

  RestaurantResponse get restaurants => _responseRestaurant;

  RestaurantDetailModel get restaurant => _responseRestaurantDetail;

  SearchRestaurantResponse get searchResult => _responseSearchRestaurant;

  ResultState get state => _state;

  String get message => _message;

  AppProvider getRestaurants() {
    _fetchRestaurants();
    return this;
  }

  Future<dynamic> _fetchRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final response = await apiService.getList();
      if (response.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'No data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _responseRestaurant = response;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = e.toString();
    }
  }

  AppProvider getRestaurant(String id) {
    fetchRestaurant(id);
    return this;
  }

  Future<dynamic> fetchRestaurant(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final response = await apiService.getDetail(id);
      if (!response.error) {
        _state = ResultState.HasData;
        notifyListeners();
        return _responseRestaurantDetail = response;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "No data found";
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error $e';
    }
  }

  void onSearch(String query) {
    _query = query;
    _searchRestaurants();
  }

  Future<dynamic> _searchRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final response = await apiService.searchRestaurant(query: _query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'No data';
      } else {
        _state = ResultState.HasSearchData;
        notifyListeners();
        return _responseSearchRestaurant = response;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = e.toString();
    }
  }
}
