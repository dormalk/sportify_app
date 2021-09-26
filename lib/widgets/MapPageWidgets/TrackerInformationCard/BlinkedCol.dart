import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/providers/MapActivityInfo.dart';

class BlinkedCol extends StatefulWidget {
  final Color fontColor = Colors.grey[700];
  final int flex;
  final String value;
  final String label;
  final double fontSize;

  BlinkedCol({this.flex, this.value, this.label, this.fontSize});
  @override
  _BlinkedColState createState() => _BlinkedColState();
}

class _BlinkedColState extends State<BlinkedCol>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Timer _timer;
  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 1);
    _timer = Timer(Duration(seconds: 3), () => _animationController.reset());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool recordIsPaused =
        Provider.of<MapActivityInfo>(context, listen: true).recordIsPaused;
    if (recordIsPaused) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.reset();
      _timer.cancel();
      _animationController.value = 1;
    }
    return Expanded(
      flex: widget.flex,
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          child: Center(
              child: Column(
            children: [
              Text(
                widget.value,
                style: TextStyle(
                    fontSize: widget.fontSize,
                    color: widget.fontColor,
                    fontWeight: FontWeight.bold),
              ),
              Text(widget.label)
            ],
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
