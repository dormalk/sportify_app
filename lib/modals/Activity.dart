import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sportify_app/modals/User.dart';

enum ActivityType { Bike, Run }

Map<ActivityType, IconData> mapActivityIcon = {
  ActivityType.Bike: Icons.directions_bike,
  ActivityType.Run: Icons.directions_run,
};

abstract class Activity {
  String id;
  ActivityType activityType;
  String ownerId;
  DateTime createdAt;
  double latitude;
  double longitude;
  String ownerImg;

  Activity();
  Activity.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.activityType = ActivityType.values
            .firstWhere((e) => e.toString() == json['activityType']),
        this.ownerId = json['ownerId'],
        this.longitude = json['longitude'],
        this.latitude = json['latitude'],
        this.createdAt = DateTime.parse(json['createdAt']);
  Map<String, dynamic> toJson();
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

  _PositionRecordInfo.fromJson(Map<String, dynamic> json)
      : this.latitude = json['latitude'],
        this.longitude = json['longitude'],
        this.speed = json['speed'],
        this.time = json['time'];

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
        'speed': this.speed,
        'time': this.time,
      };
}

class ActivityWithGeolocation extends Activity {
  List<_PositionRecordInfo> coordinates = [];

  ActivityWithGeolocation() {}
  List<LatLng> get polylineCoordinates {
    return coordinates.map((e) => LatLng(e?.latitude, e?.longitude)).toList();
  }

  void addPositionRecordInfo(
      {double latitude, double longitude, double speed, int time}) {
    coordinates.add(_PositionRecordInfo(
        latitude: latitude, longitude: longitude, speed: speed, time: time));
  }

  void destruct() {
    coordinates = [];
  }

  ActivityWithGeolocation.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    (json['coordinates'] as List<dynamic>).forEach((element) {
      this.coordinates.add(_PositionRecordInfo.fromJson(element));
    });
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'latitude': coordinates[0].latitude,
        'longitude': coordinates[0].longitude,
        'createdAt': createdAt.toString(),
        'activityType': activityType.toString(),
        'coordinates':
            coordinates.map((coordinate) => coordinate.toJson()).toList()
      };
}
