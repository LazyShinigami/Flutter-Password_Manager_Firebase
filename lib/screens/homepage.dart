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
    Map<String, Password> pwdRegister = {};
    // Entire screen - Scaffold
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 40,
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color.fromARGB(147, 147, 147, 147),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8367f7),
                Color(0xff8367f7),
                Color(0xffeeadf1),
              ],
            ),
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
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: helper.fetchAllUserPasswords(user: widget.user),
          builder: (context, snapshot) {
            var x;
            if (snapshot.hasData) {
              x = snapshot.data!.data() as Map<String, dynamic>;
              x.forEach((key, value) {
                pwdRegister[key] = Password(
                  id: value['key'],
                  clientName: value['clientName'],
                  clientPassword: value['clientPassword'],
                  clientUsername: value['clientUsername'],
                );
              });
              return GridView.count(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              print(snapshot.error);
              return Center(child: MyText("Something went wrong!"));
            }
          }),
      floatingActionButton: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Theme(
                data: ThemeData(
                  dialogBackgroundColor: const Color.fromARGB(171, 84, 0, 99),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      title: MyText(
                        'Add task',
                        size: 20,
                        weight: FontWeight.bold,
                        spacing: 2,
                      ),
                      content: Column(
                        children: [
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
                            hint: 'Enter client password',
                          ),
                          const SizedBox(height: 20),
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

                              // Add Button
                              GestureDetector(
                                onTap: () async {
                                  await helper.addPassword(
                                    user: widget.user,
                                    clientName: cNameController.text.trim(),
                                    clientPassword: cPasswordController.text,
                                    clientUsername:
                                        cUsernameController.text.trim(),
                                  );
                                  Navigator.pop(context);
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
            color: const Color.fromARGB(147, 147, 147, 147),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8367f7),
                Color(0xff8367f7),
                Color(0xffeeadf1),
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
  PasswordTile({super.key, required this.password, required this.user});
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
            return Container(
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    //         gradient: const LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Color(0xff8367f7),
                    //     Color(0xffeeadf1),
                    //   ],
                    // ),
                    title: MyText("Delete this?"),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        GestureDetector(
                          onTap: () async {
                            await helper.deletePassword(
                                password: widget.password, user: widget.user);
                            Navigator.pop(context);
                            super.setState(() {});
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
          color: const Color.fromARGB(147, 147, 147, 147),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff8367f7),
              Color(0xff8367f7),
              // Color(0xffeeadf1),
              Color(0xffeeadf1),
            ],
          ),
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
