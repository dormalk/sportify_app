import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class TrackerInformationCard extends StatefulWidget {
  const TrackerInformationCard({Key key}) : super(key: key);

  @override
  _TrackerInformationCardState createState() => _TrackerInformationCardState();
}

class _TrackerInformationCardState extends State<TrackerInformationCard> {
  String _timeFromStart;
  String _distance;

  void _listen() {
    setState(() {
      _timeFromStart =
          Provider.of<Tracker>(context, listen: true).fommatedTimer;

      _distance = Provider.of<Tracker>(context, listen: true)
          .totalDistanceInKm
          .toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(_timeFromStart), Text(_distance)],
            )
          ],
        ),
      ),
    );
  }
}
