import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pkeep_v2/model.dart';

class Helper {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Getter for MyUser object stream - monitors when the user logs in or out, returns user info if logged in
  Stream<MyUser> get userAuthStateStream {
    var result = _auth.authStateChanges();
    return result.map((user) {
      return MyUser.fromFirebaseObject(user!);
    });
  }

  // Sign-in method with email and password
  Future signInWithEmailAndPassword({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Fetching user details
  Future<DocumentSnapshot> fetchAllUserData({required MyUser user}) async {
    var docReference = _store.collection("UserInfo").doc(user.email).get();
    return docReference;
  }

  // Fetching the passwords
  Stream<DocumentSnapshot> fetchAllUserPasswords({required MyUser user}) {
    var docReference =
        _store.collection("UserPasswords").doc(user.email).snapshots();
    return docReference;
  }

  // Sign Out
  signOut() async {
    await _auth.signOut();
  }

  // Google sign in
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    print('-creds- $credential');
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign Up with Credentials
  signUpWithCreds({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _store.collection('userInfo').doc(email).set({
        'name': name,
        'password': password,
        'modePreference': 'night',
      });
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Add password
  addPassword(
      {required MyUser user,
      required String clientName,
      required String clientPassword,
      required String clientUsername}) {
    // generating random index id
    var range = Random();
    var code = range.nextInt(900000) + 100000;

    Map<String, dynamic> newData = {
      code.toString(): {
        'key': code.toString(),
        'clientUsername': clientUsername,
        'clientName': clientName,
        'clientPassword': clientPassword
      }
    };
    var docReference = _store
        .collection("UserPasswords")
        .doc(user.email)
        .set(newData, SetOptions(merge: true));
    return docReference;
  }

  deletePassword({required Password password, required MyUser user}) async {
    try {
      final docRef = _store
          .collection('UserPasswords')
          .doc(user.email)
          .update({password.id: FieldValue.delete()});
      // final updates = {password.id: deleteField()};

      // docRef.update(updates);
    } catch (e) {
      print(e);
    }
  }
}
