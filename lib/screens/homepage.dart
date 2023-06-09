import 'package:flutter/material.dart';
import 'package:pkeep_v2/commons.dart';
import 'package:pkeep_v2/helper.dart';
import 'package:pkeep_v2/model.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key, required this.user});
  MyUser user;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final helper = Helper();
  final cNameController = TextEditingController();
  final cPasswordController = TextEditingController();
  final cUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Entire screen - Scaffold
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            // color: Color.fromARGB(147, 147, 147, 147),
          ),
        ),
        title: MyText(
          'Password Manager',
          weight: FontWeight.bold,
          size: 25,
          spacing: 3,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.width * 0.15),
          child: Column(
            children: [
              MyText(
                'Hey, welcome back! 👋',
                size: 24,
                weight: FontWeight.bold,
                spacing: 1.5,
                color: Colors.black,
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
                height: 30,
              ),
              const SizedBox(height: 10),

              // Profile
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded),
                    const SizedBox(width: 10),
                    MyText(
                      'Profile',
                      weight: FontWeight.bold,
                      spacing: 1,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Logout
              GestureDetector(
                onTap: () {
                  helper.signOut();
                },
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded),
                    const SizedBox(width: 10),
                    MyText(
                      'Logout',
                      weight: FontWeight.bold,
                      spacing: 1,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Switch Account
              GestureDetector(
                onTap: () {
                  helper.signOut();
                },
                child: Row(
                  children: [
                    const Icon(Icons.swap_vert_rounded),
                    const SizedBox(width: 10),
                    MyText(
                      'Switch Account',
                      weight: FontWeight.bold,
                      spacing: 1,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/circuit.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
            stream: helper.fetchAllUserPasswords(user: widget.user),
            builder: (context, snapshot) {
              var x;
              if (snapshot.hasData) {
                if (snapshot.data!.data() != null) {
                  // Keep it here so when the stream refreshes, this variable is also refreshed
                  Map<String, Password> pwdRegister = {};

                  x = snapshot.data!.data() as Map<String, dynamic>;
                  x.forEach(
                    (key, value) {
                      pwdRegister[key] = Password(
                        id: value['key'],
                        clientName: value['clientName'],
                        clientPassword: value['clientPassword'],
                        clientUsername: value['clientUsername'],
                      );
                    },
                  );

                  return GridView.count(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      for (Password password in pwdRegister.values)
                        PasswordTile(
                          password: password,
                          user: widget.user,
                        )
                    ],
                  );
                } else {
                  return Center(
                    child: MyText(
                      'No passwords added yet!',
                      size: 20,
                      weight: FontWeight.bold,
                      spacing: 2,
                    ),
                  );
                }
              } else {
                print(snapshot.error);
                return Center(
                  child: MyText(
                    "Something went wrong!",
                    size: 20,
                    weight: FontWeight.bold,
                    spacing: 2,
                  ),
                );
              }
            }),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          String error = '';
          showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: SingleChildScrollView(
                  child: StatefulBuilder(
                    builder: (childContext, childSetState) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        content: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF473276),
                                Color(0xff6848ad),
                                Color(0xff8367f7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              MyText(
                                'Add task',
                                size: 20,
                                weight: FontWeight.bold,
                                spacing: 2,
                              ),

                              //
                              const SizedBox(height: 10),
                              (error.isEmpty)
                                  ? Container()
                                  : MyText(
                                      error,
                                      color: Colors.red,
                                      weight: FontWeight.bold,
                                      spacing: 1,
                                    ),
                              const SizedBox(height: 10),
                              //

                              MyTextField(
                                controller: cNameController,
                                label: 'Client Name',
                                hint: 'Enter client name',
                              ),
                              const SizedBox(height: 10),
                              MyTextField(
                                controller: cUsernameController,
                                label: 'Username',
                                hint: 'Enter username',
                              ),
                              const SizedBox(height: 10),
                              MyTextField(
                                controller: cPasswordController,
                                label: 'Password',
                                hint: 'Enter password',
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Cancel Button
                                  GestureDetector(
                                    onTap: () {
                                      cNameController.clear();
                                      cPasswordController.clear();
                                      cUsernameController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: MyText(
                                      'Cancel',
                                      weight: FontWeight.bold,
                                      spacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Add Button
                                  GestureDetector(
                                    onTap: () async {
                                      if (cNameController.text.isNotEmpty &&
                                          cPasswordController.text.isNotEmpty &&
                                          cUsernameController.text.isNotEmpty) {
                                        await helper.addPassword(
                                          user: widget.user,
                                          clientName:
                                              cNameController.text.trim(),
                                          clientPassword:
                                              cPasswordController.text,
                                          clientUsername:
                                              cUsernameController.text.trim(),
                                        );
                                        cNameController.clear();
                                        cPasswordController.clear();
                                        cUsernameController.clear();
                                        Navigator.pop(context);
                                      } else {
                                        error = 'There are empty fields';
                                        childSetState(() {});
                                      }
                                    },
                                    child: MyText(
                                      'Add',
                                      weight: FontWeight.bold,
                                      spacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(100),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF473276),
                Color(0xff6848ad),
                Color(0xff8367f7),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTile extends StatefulWidget {
  PasswordTile({
    super.key,
    required this.password,
    required this.user,
  });
  Password password;
  MyUser user;

  @override
  State<PasswordTile> createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  final helper = Helper();
  bool showPwd = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // delete
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF473276),
                          Color(0xff6848ad),
                          Color(0xff8367f7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText("Delete this?", size: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Cancel Button
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: MyText(
                                'Cancel',
                                weight: FontWeight.bold,
                                spacing: 1,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Delete button
                            TextButton(
                              onPressed: () async {
                                try {
                                  var _auth = Helper();
                                  await _auth.deletePassword(
                                      password: widget.password,
                                      user: widget.user);
                                } catch (e) {
                                  print(
                                      "Some shit went wrong on HomePage widget --------------> $e");
                                }

                                Navigator.pop(context);
                              },
                              child: MyText(
                                'Delete',
                                color: Colors.red,
                                weight: FontWeight.bold,
                                spacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },

      // reveal password
      onTap: () {
        showPwd = !showPwd;
        setState(() {});
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(103, 0, 0, 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(widget.password.clientName,
                weight: FontWeight.bold, spacing: 1),
            const Divider(height: 15, thickness: 0.5, color: Colors.white),
            MyText(widget.password.clientUsername, spacing: 1),
            const SizedBox(height: 5),
            (showPwd)
                ? MyText(widget.password.clientPassword, spacing: 1)
                : MyText('* * * * * *'),
          ],
        ),
      ),
    );
  }
}
