import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sportify_app/shared/widgets/BitmapAvater.dart';

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
    _initSelfIcon();
    super.initState();
  }

  void _initSelfIcon() async {
    try {
      final File _avater = await DefaultCacheManager()
          .getSingleFile(FirebaseAuth.instance.currentUser.photoURL);
      BitmapDescriptor myIconTemp =
          await convertImageFileToCustomBitmapDescriptor(_avater);
      if (this.mounted) {
        setState(() {
          _myIcon = myIconTemp;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _upsertMarker(
      {String title, LatLng pos, double huv, BitmapDescriptor icon}) {
    Marker m = Marker(
        markerId: MarkerId(title),
        icon: icon == null ? BitmapDescriptor.defaultMarkerWithHue(huv) : icon,
        position: pos);
    if (this.mounted) {
      setState(() {
        _markers[MarkerId(title)] = m;
      });
    }
  }

  void _updateLocation(Position pos) {
    if (pos != null && _googleMapController != null) {
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 17,
      )));
    }
    if (_myIcon != null) {
      _upsertMarker(
          title: 'self',
          pos: LatLng(pos.latitude, pos.longitude),
          icon: _myIcon);
    }
    if (this.mounted) {
      setState(() {
        _currentLocation = pos;
      });
    }
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
