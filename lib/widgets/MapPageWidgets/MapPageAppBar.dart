import 'package:flutter/material.dart';


class MapPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapPageAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text('Sportify'),
      automaticallyImplyLeading: false,
    );
  }
}
