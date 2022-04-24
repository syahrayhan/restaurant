import 'package:flutter/material.dart';
import 'package:restaurant/ui/detail_page.dart';
import 'package:restaurant/ui/favorite_page.dart';
import 'package:restaurant/ui/menu_list_page.dart';
import 'package:restaurant/ui/setting_page.dart';
import 'package:restaurant/utils/notification_helper.dart';

class MainBottomNavigation extends StatefulWidget {
  static const routeName = '/main-bottom-navigation';
  const MainBottomNavigation({Key? key}) : super(key: key);

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _bottomNavIndex = 0;
  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = const [
    MenuListPage(),
    FavoritePage(),
    SettingPage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  void initState() {
    _notificationHelper
        .configureSelectNotificationSubject(DetailPage.routeName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Restaurant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
