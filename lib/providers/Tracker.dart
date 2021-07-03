import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sportify_app/helper/GeoDemo.dart';
import 'package:sportify_app/helper/MathCalc.dart';

bool _isDemoRun = false;

class Tracker extends ChangeNotifier {
  List<Position> record = [];
  Timer timer;
  List<LatLng> _polylineCoordinates = [];
  int _secFromStart = 0;
  bool _recordIsActive = false;
  Position _currentPosition;

  Position get currentPosition => _currentPosition;
  bool get recordIsActive => _recordIsActive;
  String get fommatedTimer =>
      '${(_secFromStart / 60).toInt()}:${_secFromStart % 60}';

  Tracker() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _recordTick());
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

  Future<Position> getCurrentLocation() {
    if (_isDemoRun) {
      Position pos = GeoDemo.getCurrentLocation();
      return Future<Position>(() => pos);
    }
    try {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print(e);
    }
  }

  void _recordTick() async {
    _currentPosition = await getCurrentLocation();
    if (_recordIsActive) {
      _polylineCoordinates
          .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));
      _secFromStart++;
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
}
