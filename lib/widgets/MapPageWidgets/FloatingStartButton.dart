import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/widgets/MapPageWidgets/CreateActivityModal.dart';

class FloatingStartButton extends StatelessWidget {
  FloatingStartButton({Key key});

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateActivityModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    bool _recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;
    return !_recordIsActive
        ? FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () => _showDialog(context))
        : Container();
  }
}
