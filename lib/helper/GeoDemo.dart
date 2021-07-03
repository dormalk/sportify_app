import 'package:geolocator/geolocator.dart';

class GeoDemo {
  static List<Position> _positionLst = [
    _generatePosition(latitude: 32.6812702, longitude: 35.4207853),
    _generatePosition(latitude: 32.6812925, longitude: 35.4234677),
    _generatePosition(latitude: 32.6814915, longitude: 35.4235967),
    _generatePosition(latitude: 32.6816153, longitude: 35.4224323),
    _generatePosition(latitude: 32.6818543, longitude: 35.4223623),
    _generatePosition(latitude: 32.6819803, longitude: 35.4222333),
    _generatePosition(latitude: 32.6819803, longitude: 35.4219763),
    _generatePosition(latitude: 32.6818813, longitude: 35.4217133),
    _generatePosition(latitude: 32.6817831, longitude: 35.4211072),
    _generatePosition(latitude: 32.6817151, longitude: 35.4211152),
    _generatePosition(latitude: 32.6816431, longitude: 35.4211422),
    _generatePosition(latitude: 32.6815681, longitude: 35.4211422),
    _generatePosition(latitude: 32.6814731, longitude: 35.4211632),
    _generatePosition(latitude: 32.6813781, longitude: 35.4211902),
    _generatePosition(latitude: 32.6812791, longitude: 35.4212202),
  ];

  static int _currentIndex = 0;

  static Position getCurrentLocation() {
    Position pos = _positionLst[_currentIndex % _positionLst.length];
    _currentIndex++;
    return pos;
  }

  static Position _generatePosition({latitude, longitude}) {
    return Position(
        latitude: latitude,
        longitude: longitude,
        speed: 0.0,
        accuracy: 5.0,
        heading: 90.0,
        speedAccuracy: 0.5,
        altitude: 5.0,
        timestamp: null);
  }
}
