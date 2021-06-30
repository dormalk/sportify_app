import 'package:flutter/material.dart';
import 'package:sportify_app/pages/FeedPage.dart';
import 'package:sportify_app/pages/MapPage.dart';
import 'package:sportify_app/pages/RoadPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final tabs = [MapPage(), RoadPage(), FeedPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              backgroundColor: Colors.blue,
              label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Colors.green,
              label: 'Me'),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              backgroundColor: Colors.red,
              label: 'Feed'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
