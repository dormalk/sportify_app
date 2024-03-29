import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sportify_app/helper/FirestoreIntegrator.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportify_app/modals/User.dart';

class Auth extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  User _user;
  User get user => _user;

  Future googleLogin() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    final googleAuth = await googleUser.authentication;
    updateCurrentUser(FirebaseAuth.instance.currentUser);
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void updateCurrentUser(var googleUser) async {
    DocumentSnapshot<Object> res =
        await FirestoreIntegrator.usersREST.getUser(googleUser.uid);
    if (res.exists) {
      _user = User.fromJson(res.data());
    } else {
      _user = User(
          displayName: googleUser.displayName,
          id: googleUser.uid,
          email: googleUser.email,
          photoUrl: googleUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      await FirestoreIntegrator.usersREST.addUser(_user);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }
}
