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
  String _caloriesBurn;

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
      _caloriesBurn = Provider.of<Tracker>(context, listen: true)
          .totalCaloriesBurn
          .toStringAsFixed(2);
    });
  }

  Widget _buildCol({int flex, String value, String label, double fontSize}) {
    return Expanded(
      flex: flex,
      child: Container(
        child: Center(
            child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: fontSize),
            ),
            Text(label)
          ],
        )),
      ),
    );
  }

  Widget _buildDurationCol() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Container()),
        _buildCol(
            flex: 3,
            value: _timeFromStart,
            label: Labels.duration,
            fontSize: 40),
        Expanded(flex: 1, child: Container())
      ],
    );
  }

  Widget _buildSecondRowCardInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  Text(
                    _caloriesBurn,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(Labels.calories)
                ],
              ),
            )),
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
