import 'package:flutter/material.dart';
import '../widgets/MapPageWidgets/MainMap.dart';
import '../widgets/MapPageWidgets/TrackerInformationCard.dart';
import 'package:flutter/foundation.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  bool _recordIsActive = false;

  Widget _buildLayer({Widget child, double height}) {
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
      vsync: this,
      child: Container(
        height: MediaQuery.of(context).size.height * height,
        child: child,
      ),
    );
  }

  void _listen() {
    setState(() {
      _recordIsActive =
          Provider.of<Tracker>(context, listen: true).recordIsActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Container(
      child: Stack(children: [
        _buildLayer(child: MainMap(), height: _recordIsActive ? 0.75 : 1.0),
        _buildLayer(
            child: TrackerInformationCard(),
            height: _recordIsActive ? 0.25 : 0),
      ]),
    );
  }
}
