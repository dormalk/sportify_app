import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MapPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  MapPageAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) {
    bool recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;
    return recordIsActive
        ? Container(
            width: 0,
            height: MediaQuery.of(context).padding.top,
          )
        : AppBar(
            elevation: 0,
            title: const Text('Sportify'),
            automaticallyImplyLeading: false,
          );
  }
}
