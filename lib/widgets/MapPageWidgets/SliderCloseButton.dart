import 'package:flutter/material.dart';
import 'package:sportify_app/providers/MapActivityInfo.dart';
import 'package:provider/provider.dart';
import 'package:slide_button/slide_button.dart';
import 'package:sportify_app/shared/Colors.dart';
import 'package:sportify_app/shared/Labels.dart';

class SliderCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapActivityInfo>(
        builder: (ctx, info, _) =>
            info != null && info.recordIsActive && !info.recordIsPaused
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
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      slidingBarColor: CustomColor.primaryColor,
                      slideDirection: SlideDirection.LEFT,
                      initialSliderPercentage: 100.0,
                      onButtonSlide: (percentage) {
                        if (percentage < 0.1) {
                          Provider.of<MapActivityInfo>(context, listen: false)
                              .pauseActivity();
                        }
                      },
                    ))
                : Container(
                    width: 0,
                    height: 0,
                  ));
  }
}
