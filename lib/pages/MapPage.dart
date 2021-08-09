import 'package:flutter/material.dart';
import 'package:sportify_app/widgets/MapPageWidgets/AnimatedLayout.dart';
import 'package:sportify_app/widgets/MapPageWidgets/SliderCloseButton.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedLayout(
            openMode:
                Provider.of<Tracker>(context, listen: true).recordIsActive,
          ),
          SliderCloseButton(),
        ],
      ),
    );
  }
}
