import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class FloatingStartButton extends StatefulWidget {
  FloatingStartButton({Key key});

  @override
  _FloatingStartButtonState createState() => _FloatingStartButtonState();
}

class _FloatingStartButtonState extends State<FloatingStartButton> {
  @override
  Widget build(BuildContext context) {
    bool _recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;
    return !_recordIsActive
        ? FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () =>
                Provider.of<Tracker>(context, listen: false).startRecord())
        : Container();
  }
}
