import 'package:flutter/material.dart';
import 'package:sportify_app/widgets/MapPageWidgets/CreateActivityModal.dart';
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

  @override
  Widget build(BuildContext context) {
    bool _recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            _recordIsActive
                ? SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  )
                : Container(),
            _buildLayer(
                child: TrackerInformationCard(),
                height: _recordIsActive ? 0.30 : 0),
            Expanded(child: MainMap()),
          ]),
        ),
        SliderCloseButton(),
      ],
    );
  }
}
