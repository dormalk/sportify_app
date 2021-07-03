import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MapPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  MapPageAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MapPageAppBarState createState() => _MapPageAppBarState();
}

class _MapPageAppBarState extends State<MapPageAppBar> {
  bool _recordIsActive = false;

  void _listen() {
    setState(() {
      _recordIsActive =
          Provider.of<Tracker>(context, listen: true).recordIsActive;
    });
  }

//
  TextButton _buildButton({String text, Function onPress}) {
    return TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return AppBar(
      title: const Text('Sportify'),
      automaticallyImplyLeading: false,
      actions: [
        !_recordIsActive
            ? _buildButton(
                text: 'Start',
                onPress: () =>
                    Provider.of<Tracker>(context, listen: false).startRecord())
            : Container(),
        _recordIsActive
            ? _buildButton(
                text: 'Stop',
                onPress: () =>
                    Provider.of<Tracker>(context, listen: false).stopRecord())
            : Container(),
      ],
    );
  }
}
