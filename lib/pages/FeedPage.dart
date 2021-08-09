import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key key}) : super(key: key);
  // final _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Feed'),
      ),
    );
  }
}
