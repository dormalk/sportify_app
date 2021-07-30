import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  MapPageAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MapPageAppBarState createState() => _MapPageAppBarState();
}

class _MapPageAppBarState extends State<MapPageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Sportify'),
      automaticallyImplyLeading: false,
    );
  }
}
