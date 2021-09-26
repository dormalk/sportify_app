import 'package:flutter/material.dart';
import 'package:sportify_app/widgets/MapPageWidgets/AnimatedLayout.dart';
import 'package:sportify_app/widgets/MapPageWidgets/SliderCloseButton.dart';
import 'package:sportify_app/providers/MapActivityInfo.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer<MapActivityInfo>(
            builder: (ctx, info, _) => AnimatedLayout(
              openMode: info?.recordIsActive,
            ),
          ),
          SliderCloseButton(),
        ],
      ),
    );
  }
}
