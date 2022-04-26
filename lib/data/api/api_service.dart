import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant/data/models/restaurant_detail_response.dart';
import 'package:restaurant/data/models/restaurant_response.dart';
import 'package:restaurant/data/models/search_restaurant_response.dart';
import 'package:restaurant/utils/config.dart';
import 'package:restaurant/utils/constant.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final Client client;
  ApiService(this.client);

  Future<RestaurantResponse> getList() async {
    try {
      final response = await client.get(Uri.parse(Config.RESTAURANT_LIST_URL));
      if (response.statusCode == 200) {
        return RestaurantResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(Constant.failed_get_data);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SearchRestaurantResponse> searchRestaurant({String query = ""}) async {
    try {
      final response =
          await client.get(Uri.parse(Config.SEARCH_RESTAURANT_URL + query));
      if (response.statusCode == 200) {
        return SearchRestaurantResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(Constant.failed_get_data);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<RestaurantDetailModel> getDetail(String id) async {
    final response =
        await client.get(Uri.parse(Config.BASE_URL + 'detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(Constant.failed_get_data);
    }
  }
}
