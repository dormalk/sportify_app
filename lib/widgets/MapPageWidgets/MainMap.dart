import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:sportify_app/providers/Activities.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sportify_app/shared/helpers/BitmapAvater.dart';

class MainMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainMapState();
}

class MainMapState extends State<MainMap> {
  GoogleMapController _googleMapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  static Position _currentLocation;

  BitmapDescriptor _myIcon;

  @override
  void initState() {
    _initSelfIcon();
    super.initState();
  }

  void _getActivities() async {
    if (!Provider.of<TrackerInfo>(context, listen: false).recordIsActive) {
      var boundaries = await _googleMapController.getVisibleRegion();
      Provider.of<Activities>(context, listen: false)
          .getActivities(boundaries.northeast, boundaries.southwest)
          .then((res) {
        if (res.isUpdate) {
          res.activities.forEach((element) => _initActivityIcon(element));
        }
      });
    }
  }

  void _onPickActivity(String id) {
    var rival = Provider.of<Activities>(context, listen: false)
        .activities
        .firstWhere((element) => element.id == id);
    if (rival != null) {
      Provider.of<TrackerInfo>(context, listen: false)
          .playActivity(rivalActivity: rival);
    }
  }

  void _initActivityIcon(Activity activity) async {
    try {
      BitmapDescriptor iconTemp =
          await convertImageFileToCustomBitmapDescriptor(
              await DefaultCacheManager().getSingleFile(activity.ownerImg));
      this._upsertMarker(
          title: activity.id,
          icon: iconTemp,
          pos: LatLng(activity.latitude, activity.longitude),
          onTap: _onPickActivity);
    } catch (e) {
      print('ERROR || _initActivityIcon==>');
      print(e);
    }
  }

  void _initSelfIcon() async {
    try {
      BitmapDescriptor myIconTemp =
          await convertImageFileToCustomBitmapDescriptor(
              await DefaultCacheManager()
                  .getSingleFile(FirebaseAuth.instance.currentUser.photoURL));
      if (this.mounted) {
        setState(() {
          _myIcon = myIconTemp;
        });
      }
    } catch (e) {
      print('ERROR || _initSelfIcon==>');
      print(e);
    }
  }

  void _upsertMarker(
      {String title,
      LatLng pos,
      double huv,
      BitmapDescriptor icon,
      Function onTap}) {
    Marker m = Marker(
        markerId: MarkerId(title),
        icon: icon == null ? BitmapDescriptor.defaultMarkerWithHue(huv) : icon,
        position: pos,
        onTap: () => onTap != null ? onTap(title) : null);
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
        target: LatLng(pos?.latitude, pos?.longitude),
        zoom: 17,
      )));
      if (_myIcon != null) {
        _upsertMarker(
            title: 'self',
            pos: LatLng(pos?.latitude, pos?.longitude),
            icon: _myIcon);
      }
    }
    if (this.mounted) {
      setState(() {
        _currentLocation = pos;
      });
    }
  }

  void _listen() {
    _updateLocation(
        Provider.of<TrackerInfo>(context, listen: true).currentPosition);
    if (Provider.of<TrackerInfo>(context, listen: true).recordIsActive) {
      _markers.removeWhere((key, value) => key != 'self');
    }
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return _currentLocation != null
        ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  _currentLocation?.latitude, _currentLocation?.longitude),
              zoom: 17,
            ),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: Set<Polyline>.of(
                Provider.of<TrackerInfo>(context, listen: true)
                    .polylines
                    .values),
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: (controller) {
              _googleMapController = controller;
              _getActivities();
            },
            onCameraIdle: () {
              _getActivities();
            },
          )
        : Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
