import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';
import 'package:slide_button/slide_button.dart';
import 'package:sportify_app/shared/Labels.dart';

class SliderCloseButton extends StatefulWidget {
  SliderCloseButton({Key key});

  @override
  _SliderCloseButtonState createState() => _SliderCloseButtonState();
}

class _SliderCloseButtonState extends State<SliderCloseButton> {
  @override
  Widget build(BuildContext context) {
    bool _recordIsActive =
        Provider.of<Tracker>(context, listen: true).recordIsActive;
    return _recordIsActive
        ? Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            child: SlideButton(
              height: 50,
              borderRadius: 0.0,
              backgroundColor: Colors.transparent,
              slidingChild: Container(
                child: Center(
                  child: Text(
                    Labels.SLIDE_STOP_ACTIVITY,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              slidingBarColor: Colors.black.withOpacity(0.2),
              slideDirection: SlideDirection.LEFT,
              initialSliderPercentage: 100.0,
              onButtonSlide: (percentage) {
                if (percentage < 0.1) {
                  Provider.of<Tracker>(context, listen: false).stopRecord();
                }
              },
            ))
        : Container();
  }
}
