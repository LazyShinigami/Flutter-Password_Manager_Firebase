import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pkeep_v2/model.dart';

class Helper {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  // Getter for MyUser object stream - monitors when the user logs in or out, returns user info if logged in
  Stream<MyUser> get userAuthStateStream {
    var result = _auth.authStateChanges();
    return result.map((user) {
      MyUser myUser = MyUser.fromFirebaseObject(user!);

      return myUser;
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
    // try {
    await _auth.signOut();
    await _google.signOut();
    // } catch (e) {
    // print(e);
    // }
  }

  // Google sign in
  signInWithGoogle() async {
    try {
      // Shows the popup for selecting the account - from here we get the account the user is trying to sign in with
      final GoogleSignInAccount? googleSignInAccount = await _google.signIn();

      // If an account is selected, this next bit will execute
      if (googleSignInAccount != null) {
        // ensures user is signed in with their google account
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        // gives us the credentials of the user so we can use it to simply login
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Finally, we sign in using the credentials we got from the above code
        await _auth.signInWithCredential(authCredential);
        // print('@@@@@@@@@@@@@@@@@ ${_auth.currentUser!.displayName}');
        // print('@@@@@@@@@@@@@@@@@ ${_auth.currentUser!.email}');
      }
    } on FirebaseAuthException catch (e) {
      print('Shit got fucked up-> $e');
      return e.message.toString();
    }
  }

  // Google sign up
  signUpWithGoogle() async {
    try {
      // Shows the popup for selecting the account - from here we get the account the user is trying to sign in with
      final GoogleSignInAccount? googleSignInAccount = await _google.signIn();

      // If an account is selected, this next bit will execute
      if (googleSignInAccount != null) {
        // ensures user is signed in with their google account
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        // gives us the credentials of the user so we can use it to simply login
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Finally, we sign in using the credentials we got from the above code
        await _auth.signInWithCredential(authCredential);

        // Creating the user for UserInfo collection in the firestore
        String? name = _auth.currentUser!.displayName;
        String? email = _auth.currentUser!.email;
        String password = '';

        await _store.collection('UserInfo').doc().set({
          'name': name,
          'password': password,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Shit got fucked up-> $e');
      return e.message.toString();
    }
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
      await _store.collection('UserInfo').doc(email).set({
        'name': name,
        'password': password,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // user account password reset
  Future resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

//
//
//

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
          .set({password.id: FieldValue.delete()}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
}
