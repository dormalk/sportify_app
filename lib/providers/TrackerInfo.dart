import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/modals/Activities/BikeActivity.dart';
import 'package:sportify_app/modals/Activities/RunActivity.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportify_app/helper/MathCalc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportify_app/shared/Colors.dart';

String _parseToSrt(int val) {
  if (val < 10)
    return '0$val';
  else
    return '$val';
}

const double REPIRATORY_EXCHANGE_RATIO = 4.83;
const double MASS_KG = 70;

class TrackerInfo extends ChangeNotifier {
  StreamSubscription _positionStream;
  ActivityWithGeolocation pickedActivity;
  Position currentPosition;
  bool recordIsActive = false;
  bool recordIsPaused = false;
  int _activityTime = 0;
  Timer _timer;
  double totalCaloriesBurn = 0;

  // ignore: non_constant_identifier_names
  double get _VO2 => (0.2 * speed) + 3.5;
  double get _caloriesBurn => REPIRATORY_EXCHANGE_RATIO * MASS_KG * _VO2 / 1000;
  double get speed => currentPosition.speed;
  String get stringTimer =>
      '${_parseToSrt((_activityTime ~/ 60).toInt())}:${_parseToSrt(_activityTime % 60)}';
  double get totalDistanceInKm {
    double total = 0;
    if (pickedActivity == null) return 0;
    for (var i = 0; i < pickedActivity.polylineCoordinates.length - 1; i++) {
      total += MathCalc.getDistanceFromPosition(
          pickedActivity.polylineCoordinates[i],
          pickedActivity.polylineCoordinates[i + 1]);
    }
    return total;
  }

  Map<PolylineId, Polyline> get polylines {
    Map<PolylineId, Polyline> polylinesMap = {};
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: CustomColor.seconderyColor,
        points:
            pickedActivity == null ? [] : pickedActivity.polylineCoordinates,
        width: 5);
    polylinesMap[id] = polyline;
    return polylinesMap;
  }

  TrackerInfo() {
    _initGeoLocatorStream();
  }
  void _initGeoLocatorStream() {
    _positionStream = Geolocator.getPositionStream(
            distanceFilter: 1, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) {
      _onPositionUpdate(position);
    });
  }

  TrackerInfo setActivity(ActivityType activityType) {
    if (activityType == ActivityType.Run) {
      pickedActivity =
          RunActivity(ownerId: FirebaseAuth.instance.currentUser.uid);
    } else if (activityType == ActivityType.Bike) {
      pickedActivity =
          BikeActivity(ownerId: FirebaseAuth.instance.currentUser.uid);
    }

    return this;
  }

  void _onPositionUpdate(Position pos) {
    currentPosition = pos;
    if (recordIsActive) {
      pickedActivity.addPositionRecordInfo(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
          speed: currentPosition.speed,
          time: _activityTime);
    }
    notifyListeners();
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _activityTime++;
      totalCaloriesBurn += _caloriesBurn;
      notifyListeners();
    });
  }

  void playActivity() {
    this.recordIsActive = true;
    this.recordIsPaused = false;
    _initTimer();
  }

  void stopActivity() {
    this.recordIsActive = false;
    this.recordIsPaused = false;
    _timer.cancel();
    pickedActivity.positionedConrdinats = [];
    totalCaloriesBurn = 0;
    _activityTime = 0;
    notifyListeners();
  }

  void pauseActivity() {
    _timer.cancel();
    this.recordIsPaused = true;
    notifyListeners();
  }

  void dispose() {
    super.dispose();
    pickedActivity.destruct();
    _positionStream.cancel();
    _timer.cancel();
  }
}
