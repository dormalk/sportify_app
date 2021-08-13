import 'package:flutter/material.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:sportify_app/shared/Labels.dart';

class TrackerInformationCard extends StatelessWidget {
  Color fontColor = Colors.grey[700];

  Widget _buildCol({int flex, String value, String label, double fontSize}) {
    return Expanded(
      flex: flex,
      child: Container(
        child: Center(
            child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: fontSize,
                  color: fontColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(label)
          ],
        )),
      ),
    );
  }

  Widget _buildDurationCol() {
    return Consumer<TrackerInfo>(
      builder: (context, info, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: Icon(mapActivityIcon[info.pickedActivity?.activityType],
                  size: 35, color: fontColor)),
          _buildCol(
              flex: 1,
              value: info.stringTimer,
              label: Labels.duration,
              fontSize: 40),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
  }

  Widget _buildSecondRowCardInfo() {
    return Consumer<TrackerInfo>(
      builder: (context, info, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCol(
              flex: 1,
              value: info.totalCaloriesBurn.toStringAsFixed(2),
              label: Labels.calories,
              fontSize: 25),
          _buildCol(
              flex: 1,
              value: info.speed.toStringAsFixed(2),
              label: Labels.velocity,
              fontSize: 25),
          _buildCol(
              flex: 1,
              value: info.totalDistanceInKm.toStringAsFixed(2),
              label: Labels.distance,
              fontSize: 25),
        ],
      ),
    );
  }

  Widget _buildCardInfo() {
    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: Wrap(
        runAlignment: WrapAlignment.spaceAround,
        children: [_buildDurationCol(), _buildSecondRowCardInfo()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: _buildCardInfo(),
    );
  }
}
