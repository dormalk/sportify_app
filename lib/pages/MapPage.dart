import 'package:flutter/material.dart';
import '../widgets/MainMap.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainMap(),
    );
  }
}
