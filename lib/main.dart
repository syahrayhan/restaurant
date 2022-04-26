import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/common.dart';
import 'package:restaurant/common/navigation.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/db/database_helper.dart';
import 'package:restaurant/data/preferences/preferences_helper.dart';
import 'package:restaurant/provider/app_provider.dart';
import 'package:restaurant/provider/database_provider.dart';
import 'package:restaurant/provider/localization_provider.dart';
import 'package:restaurant/provider/preferences_provider.dart';
import 'package:restaurant/provider/scheduling_restaurant_provider.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/ui/main_bottom_navigation.dart';
import 'package:restaurant/ui/menu_list_page.dart';
import 'package:restaurant/ui/search_page.dart';
import 'package:restaurant/ui/splash_screen.dart';
import 'package:restaurant/common/style.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:restaurant/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotification(flutterLocalNotificationsPlugin);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocalizationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AppProvider(apiService: ApiService(http.Client())).getRestaurants(),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingRestaurantProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      builder: (context, child) {
        final provide = Provider.of<LocalizationProvider>(context);
        return MaterialApp(
          navigatorKey: navigatorKey,
          locale: provide.locale,
          title: "Restaurant",
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                  secondary: secondaryColor,
                  onPrimary: onPrimary,
                ),
            textTheme: myTextTheme,
            appBarTheme: const AppBarTheme(elevation: 0),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onPrimary: Colors.black,
                  textStyle: const TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            MenuListPage.routeName: (context) => const MenuListPage(),
            SearchPage.routeName: (context) => const SearchPage(),
            MainBottomNavigation.routeName: (context) =>
                const MainBottomNavigation(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == DetailPage.routeName) {
              final args = settings.arguments as DetailPage;
              return MaterialPageRoute(
                builder: (context) {
                  return DetailPage(restaurantId: args.restaurantId);
                },
              );
            }
            return null;
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
