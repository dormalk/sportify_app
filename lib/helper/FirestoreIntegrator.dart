import 'package:sportify_app/modals/Activity.dart';
import 'package:sportify_app/modals/User.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _UsersREST {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User userToAdd) {
    return _users.doc(userToAdd.id).set(userToAdd.toJson());
  }

  Future<void> updateUser(User userToUpdate) {
    return _users.doc(userToUpdate.id).update(userToUpdate.toJson());
  }

  Future<DocumentSnapshot<Object>> getUser(String id) {
    return _users.doc(id).get();
  }
}

class _ActivityREST {
  CollectionReference _activities =
      FirebaseFirestore.instance.collection('activities');

  Future<DocumentReference<Object>> addNewActivity(Activity activity) {
    return _activities.add(activity.toJson());
  }

  Future<QuerySnapshot<Object>> getActivities(
      LatLng topleft, LatLng bottomright, List<String> ids) {
    if (ids.isEmpty) ids.add('0');
    var query = _activities.where(FieldPath.documentId, whereNotIn: ids);
    query.where('latitude', isLessThan: topleft.latitude);
    query.where('latitude', isGreaterThan: bottomright.latitude);
    return query.get();
  }
}

class FirestoreIntegrator {
  static final _UsersREST usersREST = _UsersREST();
  static final _ActivityREST activityREST = _ActivityREST();
}
