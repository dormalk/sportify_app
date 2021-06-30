import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  List<LatLng> _polylineCoordinates = [];

  static Position _currentLocation;
  @override
  void initState() {
    // _getCurrentLocation().then((position) => _updateLocation(position));
    _addMarker(
        'marker1', LatLng(37.777777, -122.23233), BitmapDescriptor.hueBlue);
    _addMarker(
        'marker2', LatLng(37.777777, -122.43233), BitmapDescriptor.hueGreen);

    _addPolyline(LatLng(37.777777, -122.23255));
    _addPolyline(LatLng(37.798765, -122.23238));

    super.initState();
  }

  void _addMarker(String title, LatLng pos, double color) {
    Marker m = Marker(
        markerId: MarkerId(title),
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        position: pos);
    setState(() {
      _markers[MarkerId(title)] = m;
    });
  }

  void _updateLocation(Position pos) {
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 14.4746,
    )));

    setState(() {
      _currentLocation = pos;
    });
  }

  Future<Position> _getCurrentLocation() {
    try {
      return Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print(e);
    }
  }

  void _addPolyline(LatLng pos) {
    _polylines.clear();
    _polylineCoordinates.add(LatLng(pos.latitude, pos.longitude));
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: _polylineCoordinates,
        width: 5);
    _polylines[id] = polyline;
    setState(() {});
  }

  // static final _initialCameraPosition = CameraPosition(
  //   target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
  //   zoom: 14.4746,
  // );

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(37.777777, -122.23233),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      polylines: Set<Polyline>.of(_polylines.values),
      markers: Set<Marker>.of(_markers.values),
      onMapCreated: (controller) => _googleMapController = controller,
    );
  }
}
