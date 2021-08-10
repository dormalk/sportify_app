import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ActivityType { Bike, Run }

Map<ActivityType, IconData> mapActivityIcon = {
  ActivityType.Bike: Icons.directions_bike,
  ActivityType.Run: Icons.directions_run,
};

abstract class Activity {
  ActivityType activityType;
  String ownerId;
  DateTime createdAt;
}

class _PositionRecordInfo {
  double latitude;
  double longitude;
  double speed;
  int time;

  _PositionRecordInfo(
      {@required this.latitude,
      @required this.longitude,
      @required this.speed,
      @required this.time});
}

class ActivityWithGeolocation extends Activity {
  List<_PositionRecordInfo> positionedConrdinats = [];

  List<LatLng> get polylineCoordinates {
    return positionedConrdinats
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  void addPositionRecordInfo(
      {@required latitude,
      @required longitude,
      @required speed,
      @required time}) {
    positionedConrdinats.add(_PositionRecordInfo(
        latitude: latitude, longitude: longitude, speed: speed, time: time));
  }

  void destruct() {
    positionedConrdinats = [];
  }
}
