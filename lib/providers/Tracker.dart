import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/helper/MathCalc.dart';

class Tracker extends ChangeNotifier {
  List<Position> record = [];
  List<LatLng> _polylineCoordinates = [];
  int _secFromStart = 0;
  bool _recordIsActive = false;
  Position _currentPosition;

  Position get currentPosition => _currentPosition;
  bool get recordIsActive => _recordIsActive;
  String get fommatedTimer =>
      '${(_secFromStart / 60).toInt()}:${_secFromStart % 60}';

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
      notifyListeners();
    });
  }

  double get totalDistanceInKm {
    double total = 0;
    for (var i = 0; i < _polylineCoordinates.length - 1; i++) {
      total += MathCalc.getDistanceFromPosition(
          _polylineCoordinates[i], _polylineCoordinates[i + 1]);
    }
    return total;
  }

  Map<PolylineId, Polyline> get polylines {
    Map<PolylineId, Polyline> polylinesMap = {};
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: _polylineCoordinates,
        width: 5);
    polylinesMap[id] = polyline;
    return polylinesMap;
  }

  void _recordTick(Position newPos) async {
    _currentPosition = newPos;
    if (_recordIsActive) {
      _polylineCoordinates
          .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));
    }
    notifyListeners();
  }

  void startRecord() {
    _recordIsActive = true;
    _secFromStart = 0;
  }

  void stopRecord() {
    _recordIsActive = false;
    clearMyRecord();
  }

  void clearMyRecord() {
    _polylineCoordinates = [];
    notifyListeners();
  }

  void dispose() {
    _positionStream.cancel();
    _timer.cancel();
  }
}
