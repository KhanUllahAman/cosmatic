import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmatic/models/user_model/user_model.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaseAuthHelper {
  static FireBaseAuthHelper instance = FireBaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      showMessage(error.code);
      return false;
    }
  }

  Future<bool> signUp(
      String email, String password, String name, BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );
      _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();
      showMessage(error.code);
      return false;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
