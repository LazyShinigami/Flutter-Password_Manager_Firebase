import 'package:flutter/material.dart';
import 'package:pkeep_v2/auth.dart';
import 'package:pkeep_v2/commons.dart';
import 'package:pkeep_v2/helper.dart';
import 'package:pkeep_v2/model.dart';
import 'package:pkeep_v2/screens/homepage%20copy.dart';
import 'package:pkeep_v2/screens/homepage.dart';

class Root extends StatelessWidget {
  Root({super.key});
  final auth = Helper();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.userAuthStateStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          MyUser user = snapshot.data!;
          return HomepageCopy(
            user: user,
          );
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
