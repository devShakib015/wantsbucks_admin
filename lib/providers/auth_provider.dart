import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wantsbucks_admin/theming/color_constants.dart';

class AuthProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _adminCollection = FirebaseFirestore.instance.collection("admin");

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<QuerySnapshot> getAdmin() async {
    return _adminCollection.get();
  }

  Future<UserCredential> signIn(
      BuildContext context, String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Phoenix.rebirth(context);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: dangerColor,
            duration: Duration(seconds: 2),
            content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: dangerColor,
            duration: Duration(seconds: 2),
            content: Text("Wrong password provided for that user.")));
      }
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Phoenix.rebirth(context);
  }
}
