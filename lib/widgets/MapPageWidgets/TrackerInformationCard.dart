import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/shared/Labels.dart';

class TrackerInformationCard extends StatefulWidget {
  const TrackerInformationCard({Key key}) : super(key: key);

  @override
  _TrackerInformationCardState createState() => _TrackerInformationCardState();
}

class _TrackerInformationCardState extends State<TrackerInformationCard> {
  String _timeFromStart;
  String _distance;
  String _velocity;

  void _listen() {
    setState(() {
      _timeFromStart =
          Provider.of<Tracker>(context, listen: true).fommatedTimer;

      _distance = Provider.of<Tracker>(context, listen: true)
          .totalDistanceInKm
          .toStringAsFixed(2);
      _velocity = Provider.of<Tracker>(context, listen: true)
          .velocity
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
                child: Column(
              children: [
                Text(
                  _timeFromStart,
                  style: TextStyle(fontSize: 40),
                ),
                Text(Labels.duration)
              ],
            )),
          ),
        ),
        Expanded(flex: 1, child: Container())
      ],
    );
  }

  Widget _buildSecondRowCardInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              children: [
                Text(
                  _velocity,
                  style: TextStyle(fontSize: 25),
                ),
                Text(Labels.velocity)
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  Text(
                    _distance,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(Labels.distance)
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildCardInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [_buildDurationCol(), _buildSecondRowCardInfo()],
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
