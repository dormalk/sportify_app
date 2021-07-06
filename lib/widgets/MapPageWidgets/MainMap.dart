import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class MainMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polylines = {};

  static Position _currentLocation;

  BitmapDescriptor _myIcon;

  @override
  void initState() {
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(size: Size(48, 48)), 'images/runner_icon')
    //     .then((onValue) {
    //   _myIcon = onValue;
    // });

    super.initState();
  }

  void _updateMarker(
      {String title, LatLng pos, double color, BitmapDescriptor icon}) {
    Marker m = Marker(
        markerId: MarkerId(title),
        infoWindow: InfoWindow(title: title),
        icon:
            icon == null ? BitmapDescriptor.defaultMarkerWithHue(color) : icon,
        position: pos);
    setState(() {
      _markers[MarkerId(title)] = m;
    });
  }

  void _updateLocation(Position pos) {
    if (pos != null && _googleMapController != null) {
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 17,
      )));
    }
    setState(() {
      _currentLocation = pos;
    });
  }

  void _listen() {
    _polylines = Provider.of<Tracker>(context, listen: true).polylines;
    _updateLocation(
        Provider.of<Tracker>(context, listen: true).currentPosition);
  }

  @override
  Widget build(BuildContext context) {
    _listen();

    return _currentLocation != null
        ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(_currentLocation.latitude, _currentLocation.longitude),
              zoom: 17,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(_polylines.values),
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: (controller) => _googleMapController = controller,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
