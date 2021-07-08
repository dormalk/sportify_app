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

  Widget _buildDurationCol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
                child: Text(
              _timeFromStart,
              style: TextStyle(fontSize: 40),
            )),
          ),
        ),
        Expanded(flex: 1, child: Container())
      ],
    );
  }

  Widget _buildCardInfo() {
    return Column(
      children: [
        _buildDurationCol(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [Text(_timeFromStart), Text(_distance)],
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildCardInfo(),
      ),
    );
  }
}
