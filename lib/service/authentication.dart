import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ha_angricola/models/user.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name, String location, String phoneNumber);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {

  final Firestore _db = Firestore.instance;
  CollectionReference ref;


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<String> signIn(String email, String password) async {

    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password, String name, String location, String phoneNumber) async {

    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName  =name;

    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    //New content added
    User user1 = new User(numberPhone: phoneNumber, location: location, firstName: name, email: email, id: user.uid);
    await _db.collection('users').document(user.uid).setData(user1.toJson());

    return user.uid;
  }



  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}


/**
 *  Future<String> signUp(String e .mail, String password, String name) async {

    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName  =name;

    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
    email: email, password: password);
    FirebaseUser user = result.user;


    Firestore.instance.collection('users').document().setData({ 'userid':user.uid, 'displayname':name });

    return user.uid;
    }
    }
 **/