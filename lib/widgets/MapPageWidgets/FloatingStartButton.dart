import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
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
        Provider.of<TrackerInfo>(context, listen: true).recordIsActive;
    return !_recordIsActive
        ? FloatingActionButton(
            elevation: 1,
            backgroundColor: Color(0XFF000033),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _showDialog(context))
        : Container();
  }
}
