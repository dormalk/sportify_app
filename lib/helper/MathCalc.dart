import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MathCalc {
  static double getDistanceFromPosition(LatLng p1, LatLng p2) {
    final R = 6371;
    if (p1 == null || p2 == null) return 0;
    final dLat = _deg2rand(p2.latitude - p1.latitude);
    final dLong = _deg2rand(p2.longitude - p1.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rand(p1.latitude)) *
            cos(_deg2rand(p2.latitude)) *
            sin(dLong / 2) *
            sin(dLong / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c;
    return d;
  }

  static double _deg2rand(double deg) {
    return deg * (pi / 180);
  }
}
