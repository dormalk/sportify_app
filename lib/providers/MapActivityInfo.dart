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

class MapActivityInfo extends ChangeNotifier {
  StreamSubscription _positionStream;
  ActivityWithGeolocation pickedActivity;
  Position currentPosition;
  bool recordIsActive = false;
  bool recordIsPaused = false;
  int _activityTime = 0;
  Timer _timer;
  double totalCaloriesBurn = 0;
  Activity rivalActivity;
  List<LatLng> rivalPositions = [];
  Map<MarkerId, Marker> _markers = {};
  Map<MarkerId, Marker> get markers {
    if (this.recordIsActive) {
      return new Map.fromIterable(_markers.keys.where((k) {
        if (hasRival()) {
          return k.value == 'self' || k.value == rivalActivity.id;
        } else {
          return k.value == 'self';
        }
      }), key: (k) => k, value: (k) => _markers[k]);
    } else {
      return _markers;
    }
  }

  // ignore: non_constant_identifier_names
  double get _VO2 => (0.2 * speed) + 3.5;
  double get _caloriesBurn => REPIRATORY_EXCHANGE_RATIO * MASS_KG * _VO2 / 1000;
  double get speed => currentPosition?.speed;
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
    if (hasRival()) {
      PolylineId rivalId = PolylineId(rivalActivity.id);
      Polyline rival = Polyline(
          polylineId: rivalId,
          color: Colors.red,
          points: rivalPositions,
          width: 5);
      polylinesMap[rivalId] = rival;
    }
    return polylinesMap;
  }

  MapActivityInfo() {
    _initGeoLocatorStream();
  }

  void _initGeoLocatorStream() {
    _positionStream = Geolocator.getPositionStream(
            distanceFilter: 1, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) {
      _onPositionUpdate(position);
    });
  }

  MapActivityInfo setActivity(ActivityType activityType) {
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
          latitude: currentPosition?.latitude,
          longitude: currentPosition?.longitude,
          speed: currentPosition?.speed,
          time: _activityTime);
    }
    notifyListeners();
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _activityTime++;
      totalCaloriesBurn += _caloriesBurn;
      if (hasRival()) {
        if (rivalActivity.activityType == ActivityType.Bike ||
            rivalActivity.activityType == ActivityType.Run) {
          var positionInfo = (this.rivalActivity as ActivityWithGeolocation)
              .coordinates
              .firstWhere((element) => element.time == _activityTime,
                  orElse: () => null);
          if (positionInfo != null) {
            rivalPositions
                .add(LatLng(positionInfo.latitude, positionInfo.longitude));
          }
        }
      }
      notifyListeners();
    });
  }

  void playActivity({Activity rivalActivity}) {
    if (rivalActivity != null) this.rivalActivity = rivalActivity;
    this.recordIsActive = true;
    this.recordIsPaused = false;
    _initTimer();
  }

  bool hasRival() {
    return this.rivalActivity != null;
  }

  void upsertMarker(
      {String title,
      LatLng pos,
      double huv,
      BitmapDescriptor icon,
      Function onTap}) {
    Marker existMarker;
    if (_markers[MarkerId(title)] != null) {
      existMarker = _markers[MarkerId(title)];
    }
    Marker m = Marker(
        markerId: existMarker != null ? existMarker.markerId : MarkerId(title),
        icon: existMarker != null
            ? existMarker.icon
            : icon == null
                ? BitmapDescriptor.defaultMarkerWithHue(huv)
                : icon,
        position: existMarker != null ? existMarker.position : pos,
        onTap: existMarker != null
            ? existMarker.onTap
            : () => onTap != null ? onTap(title) : null);
    _markers[MarkerId(title)] = m;
    notifyListeners();
  }

  void stopActivity() {
    this.recordIsActive = false;
    this.recordIsPaused = false;
    this.rivalActivity = null;
    this.rivalPositions = [];
    if (pickedActivity != null) pickedActivity.coordinates = [];
    _timer.cancel();
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
