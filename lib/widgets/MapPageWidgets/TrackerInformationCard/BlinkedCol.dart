import 'package:flutter/material.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:sportify_app/shared/Colors.dart';
import 'package:sportify_app/shared/Labels.dart';
import '../ActivityPauseRow.dart';

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

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool recordIsPaused =
        Provider.of<TrackerInfo>(context, listen: true).recordIsPaused;
    if (recordIsPaused) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
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
