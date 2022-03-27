import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/common/common.dart';
import 'package:restaurant/provider/app_provider.dart';
import 'package:restaurant/provider/localization_provider.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/ui/menu_list_page.dart';
import 'package:restaurant/ui/search_page.dart';
import 'package:restaurant/ui/splash_screen.dart';
import 'package:restaurant/common/style.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LocalizationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AppProvider(),
          ),
        ],
        builder: (context, child) {
          final provide = Provider.of<LocalizationProvider>(context);
          return MaterialApp(
            locale: provide.locale,
            title: "Restaurant",
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: Theme
                  .of(context)
                  .colorScheme
                  .copyWith(
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
        });
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
