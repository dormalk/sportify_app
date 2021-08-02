import 'package:flutter/material.dart';
import 'package:sportify_app/pages/FeedPage.dart';
import 'package:sportify_app/pages/MapPage.dart';
import 'package:sportify_app/pages/MePage.dart';
import 'package:sportify_app/widgets/MapPageWidgets/MapPageAppBar.dart';
import 'package:sportify_app/widgets/MePageWidgets/MePageAppBar.dart';

import 'MapPageWidgets/FloatingStartButton.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _tabs = [MapPage(), MePage(), FeedPage()];

  @override
  Widget build(BuildContext context) {
    bool _recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;
    final _appBars = [
      !_recordIsActive ? MapPageAppBar() : null,
      MePageAppBar(),
      null
    ];

    return Scaffold(
      floatingActionButton: _currentIndex == 0 ? FloatingStartButton() : null,
      body: _tabs[_currentIndex],
      appBar: _appBars[_currentIndex],
      bottomNavigationBar: _recordIsActive
          ? null
          : BottomNavigationBar(
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
