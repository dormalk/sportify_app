import 'package:flutter/material.dart';

class TrackerInformationCard extends StatefulWidget {
  const TrackerInformationCard({Key key}) : super(key: key);

  @override
  _TrackerInformationCardState createState() => _TrackerInformationCardState();
}

class _TrackerInformationCardState extends State<TrackerInformationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Center(
        child: const Text('test'),
      ),
    );
  }
}
