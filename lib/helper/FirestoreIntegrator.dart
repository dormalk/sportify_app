import 'package:sportify_app/modals/Activity.dart';
import 'package:sportify_app/modals/User.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class FirestoreIntegrator {
  static final _UsersREST usersREST = _UsersREST();
  static final _ActivityREST activityREST = _ActivityREST();
}
