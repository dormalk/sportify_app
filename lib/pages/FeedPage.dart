import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Auth.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key key}) : super(key: key);
  TextButton _buildButton({String text, Function onPress}) {
    return TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(color: Colors.black),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildButton(
            text: 'Logout',
            onPress: () => Provider.of<Auth>(context, listen: false).logout()),
      ),
    );
  }
}
