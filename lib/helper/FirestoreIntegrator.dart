import 'package:sportify_app/modals/User.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class _UsersREST {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User userToAdd) {
    return _users.add(userToAdd.toJson());
  }

  Future<void> updateUser(User userToUpdate) {
    return _users.doc(userToUpdate.id).update(userToUpdate.toJson());
  }

  Future<DocumentSnapshot<Object>> getUser(String id) {
    return _users.doc(id).get();
  }
}

class FirestoreIntegrator {
  static final _UsersREST usersREST = _UsersREST();
}
