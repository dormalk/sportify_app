import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/helper/MathCalc.dart';
import 'package:sportify_app/modals/Activity.dart';

import '../modals/Activity.dart';
import 'package:firebase_auth/firebase_auth.dart';

String _parseToSrt(int val) {
  if (val < 10)
    return '0$val';
  else
    return '$val';
}

const double REPIRATORY_EXCHANGE_RATIO = 4.83;
const double MASS_KG = 70;

class Tracker extends ChangeNotifier {
  Activity currentActivity;

  int _secFromStart = 0;
  bool _recordIsActive = false;
  // ignore: non_constant_identifier_names
  double get _VO2 => (0.2 * velocity) + 3.5;
  Position _currentPosition;
  double totalCaloriesBurn = 0;
  double get _caloriesBurn => REPIRATORY_EXCHANGE_RATIO * MASS_KG * _VO2 / 1000;
  double get velocity => _currentPosition.speed;
  Position get currentPosition => _currentPosition;
  bool get recordIsActive => _recordIsActive;
  String get fommatedTimer =>
      '${_parseToSrt((_secFromStart ~/ 60).toInt())}:${_parseToSrt(_secFromStart % 60)}';

  StreamSubscription _positionStream;
  Timer _timer;

  Tracker() {
    this.initGeoLocation();
    this.initTimer();
  }

  void initGeoLocation() {
    _positionStream = Geolocator.getPositionStream(
            distanceFilter: 1, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) => _recordTick(position));
  }

  void initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _secFromStart++;
      totalCaloriesBurn += _caloriesBurn;
      notifyListeners();
    });
  }

  double get totalDistanceInKm {
    double total = 0;
    if (currentActivity == null) return 0;
    for (var i = 0; i < currentActivity.polylineCoordinates.length - 1; i++) {
      total += MathCalc.getDistanceFromPosition(
          currentActivity.polylineCoordinates[i],
          currentActivity.polylineCoordinates[i + 1]);
    }
    return total;
  }

  Map<PolylineId, Polyline> get polylines {
    Map<PolylineId, Polyline> polylinesMap = {};
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points:
            currentActivity == null ? [] : currentActivity.polylineCoordinates,
        width: 5);
    polylinesMap[id] = polyline;
    return polylinesMap;
  }

  void _recordTick(Position newPos) async {
    _currentPosition = newPos;
    if (_recordIsActive) {
      currentActivity.polylineCoordinates
          .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));
    }
    notifyListeners();
  }

  void startRecord(ActivityType activityType) {
    currentActivity = Activity(
        activityType: activityType,
        ownerId: FirebaseAuth.instance.currentUser.uid);
    _recordIsActive = true;
    _secFromStart = 0;
    totalCaloriesBurn = 0;
  }

  void stopRecord() {
    _recordIsActive = false;
    clearMyRecord();
  }

  void clearMyRecord() {
    currentActivity.polylineCoordinates = [];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
    _timer.cancel();
  }
}
