import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ActivityType { Bike, Run }

Map<ActivityType, IconData> mapActivityIcon = {
  ActivityType.Bike: Icons.directions_bike,
  ActivityType.Run: Icons.directions_run,
};

class Activity {
  ActivityType activityType;
  String ownerId;
  DateTime createdAt;
  List<LatLng> polylineCoordinates = [];

  Activity({this.activityType, this.ownerId});
}
