import 'package:flutter/material.dart';
import '../widgets/MapPageWidgets/MainMap.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainMap(),
    );
  }
}
