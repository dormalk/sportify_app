import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Auth.dart';
import 'package:provider/provider.dart';

class MePageAppBar extends StatefulWidget implements PreferredSizeWidget {
  MePageAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MePageAppBarState createState() => _MePageAppBarState();
}

class _MePageAppBarState extends State<MePageAppBar> {
  void _listen() {}

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
      backgroundColor: Colors.green,
      title: const Text('Sportify'),
      automaticallyImplyLeading: false,
      actions: [
        _buildButton(
            text: 'Logout',
            onPress: () => Provider.of<Auth>(context, listen: false).logout())
      ],
    );
  }
}
