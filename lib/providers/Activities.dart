import 'package:flutter/material.dart';
import 'package:sportify_app/helper/FirestoreIntegrator.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activities extends ChangeNotifier {
  List<Activity> activities = [];

  void addActivity(Activity activity) async {
    DocumentReference<Object> res =
        await FirestoreIntegrator.activityREST.addNewActivity(activity);
    print(res.id);
    activity.id = res.id;
    activities.add(activity);
    notifyListeners();
  }
}
