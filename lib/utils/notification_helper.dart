import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/data/models/restaurant_response.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  final _random = Random();

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantResponse restaurant) async {
    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "Restaurant reminder";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Rekomendasi restaurant</b>";
    final int randomData = getRandom(0, restaurant.count - 1);
    print('randomData: $randomData');
    var titleNews = restaurant.restaurants[randomData].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleNews,
      platformChannelSpecifics,
      payload: json.encode({"number": randomData, "data": restaurant.toJson()}),
    );
  }

  void configureSelectNotificationSubject(String routeName) async {
    print('configureSelectNotificationSubject');
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestaurantResponse.fromJson(json.decode(payload)['data']);
        var restaurantId = data.restaurants[json.decode(payload)['number']].id;
        Navigation.intentWithData(
            routeName, DetailPage(restaurantId: restaurantId));
      },
    );
  }

  int getRandom(int min, int max) => min + _random.nextInt(max - min);
}
