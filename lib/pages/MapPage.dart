import 'package:flutter/material.dart';
import 'package:sportify_app/widgets/MapPageWidgets/SliderCloseButton.dart';
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
        height: (MediaQuery.of(context).size.height -
                Scaffold.of(context).appBarMaxHeight -
                kBottomNavigationBarHeight) *
            height,
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            _buildLayer(
                child: TrackerInformationCard(),
                height: _recordIsActive ? 0.30 : 0),
            _buildLayer(child: MainMap(), height: _recordIsActive ? 0.7 : 1.0),
          ]),
        ),
        SliderCloseButton(),
      ],
    );
  }
}
