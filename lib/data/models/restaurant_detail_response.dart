import 'package:restaurant/data/models/detail_restaurant.dart';

class RestaurantDetailModel {
  RestaurantDetailModel({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  bool error;
  String message;
  DetailRestaurant restaurant;

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailModel(
        error: json["error"],
        message: json["message"],
        restaurant: DetailRestaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}