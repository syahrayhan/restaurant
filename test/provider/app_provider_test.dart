import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/data/models/detail_restaurant.dart';
import 'package:restaurant/data/models/restaurant_detail_response.dart';
import 'package:restaurant/provider/app_provider.dart';

import 'app_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  var detailRestaurant = {
    "error": false,
    "message": "success",
    "restaurant": {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description":
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
      "city": "Medan",
      "address": "Jln. Pandeglang no 19",
      "pictureId": "14",
      "categories": [
        {"name": "Italia"},
        {"name": "Modern"}
      ],
      "menus": {
        "foods": [
          {"name": "Paket rosemary"},
          {"name": "Toastie salmon"}
        ],
        "drinks": [
          {"name": "Es krim"},
          {"name": "Sirup"}
        ]
      },
      "rating": 4.2,
      "customerReviews": [
        {
          "name": "Ahmad",
          "review": "Tidak rekomendasi untuk pelajar!",
          "date": "13 November 2019"
        }
      ]
    }
  };

  group('AppProvider Test', () {
    const id = 'rqdv5juczeskfw1e867';
    final mockApiService = MockApiService();
    late AppProvider appProvider;

    setUp(() {
      appProvider = AppProvider(apiService: mockApiService);
    });

    test('Verify json parsing, Check detail resturant by id from API',
        () async {
      var aa = RestaurantDetailModel.fromJson(detailRestaurant);
      //stub
      when(mockApiService.getDetail(id))
          .thenAnswer((value) => Future.value(aa));
      //act
      await appProvider.fetchRestaurant(id);
      var testDetailRestaurantId = appProvider.restaurant.restaurant.id == id;
      //assert
      expect(testDetailRestaurantId, true);
    });
  });
}
