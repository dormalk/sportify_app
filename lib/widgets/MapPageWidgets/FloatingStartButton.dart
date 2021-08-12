import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/shared/Colors.dart';

class FloatingStartButton extends StatefulWidget {
  FloatingStartButton({Key key});

  @override
  _FloatingStartButtonState createState() => _FloatingStartButtonState();
}

class _FloatingStartButtonState extends State<FloatingStartButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<double> _animationIcon;
  Animation<Color> _animationColor;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animationIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationColor = ColorTween(
      begin: CustomColor.seconderyColor,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    isOpened = !isOpened;
  }

  Widget _buildIconButton(ActivityType activityType) {
    return Container(
      child: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          _animationController.reverse().then((value) =>
              Provider.of<TrackerInfo>(context, listen: false)
                  .setActivity(activityType)
                  .playActivity());
        },
        tooltip: 'Bike',
        backgroundColor: Colors.grey[200],
        child: Icon(mapActivityIcon[activityType], color: Colors.black),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        elevation: 2,
        backgroundColor: _animationColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !Provider.of<TrackerInfo>(context, listen: true).recordIsActive
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * 2.0,
                  0.0,
                ),
                child: _buildIconButton(ActivityType.Run),
              ),
              Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value,
                  0.0,
                ),
                child: _buildIconButton(ActivityType.Bike),
              ),
              toggle(),
            ],
          )
        : Container();
  }
}
