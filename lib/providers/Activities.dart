import 'package:flutter/material.dart';
import 'package:sportify_app/helper/FirestoreIntegrator.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityResponse {
  bool isUpdate;
  List<Activity> activities;
  ActivityResponse({this.isUpdate, this.activities});
}

class Activities extends ChangeNotifier {
  List<Activity> activities = [];

  void addActivity(Activity activity) async {
    DocumentReference<Object> res =
        await FirestoreIntegrator.activityREST.addNewActivity(activity);
    activity.id = res.id;
    activities.add(activity);
    notifyListeners();
  }

  Future<ActivityResponse> getActivities(
      LatLng topleft, LatLng bottomright) async {
    List<String> ids = activities.map((activity) => activity.id).toList();
    bool isUpdate = false;
    QuerySnapshot<Object> res = await FirestoreIntegrator.activityREST
        .getActivities(topleft, bottomright, ids);

    for (var element in res.docs) {
      if (element.exists) {
        Map<String, dynamic> dataJson = element.data();
        if (dataJson['activityType'] == 'ActivityType.Bike' ||
            dataJson['activityType'] == 'ActivityType.Run') {
          ActivityWithGeolocation activity =
              ActivityWithGeolocation.fromJson(dataJson);
          activity.id = element.id;
          var userOwner =
              await FirestoreIntegrator.usersREST.getUser(activity.ownerId);
          if (userOwner.exists) {
            activity.ownerImg =
                (userOwner.data() as Map<dynamic, dynamic>)['photoUrl'];
          }
          isUpdate = true;
          this.activities.add(activity);
        }
      }
    }
    this.activities.forEach((element) => print(element.latitude));
    if (isUpdate) {
      notifyListeners();
    }
    return ActivityResponse(isUpdate: isUpdate, activities: this.activities);
  }
}
