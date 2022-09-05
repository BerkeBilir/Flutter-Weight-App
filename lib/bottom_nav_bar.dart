import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
import 'profile.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({Key? key}) : super(key: key);

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Ana Sayfa'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profil'.tr,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}