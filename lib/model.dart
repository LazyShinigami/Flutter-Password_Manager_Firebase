import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String? email, name, password;
  MyUser();
  MyUser.fromFirebaseObject(User user) {
    email = user.email;
    // name = map['name'];
  }
}

class Password {
  String clientName, clientPassword, clientUsername, id;
  Password(
      {required this.id,
      required this.clientName,
      required this.clientPassword,
      required this.clientUsername});
}
