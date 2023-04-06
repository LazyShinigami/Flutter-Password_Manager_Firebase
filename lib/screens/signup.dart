import 'package:flutter/material.dart';
import 'package:pkeep_v2/commons.dart';
import 'package:pkeep_v2/helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.showLoginPage});
  final VoidCallback showLoginPage;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final helper = Helper();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        height: double.infinity,
        width: double.infinity,

        // Giving background image to the screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/circuit.jpeg'),
            fit: BoxFit.cover,
          ),
        ),

        //
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.925,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // google login
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    await helper.signUpWithGoogle();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/google.png'),
                        MyText(
                          'Register with Google',
                          color: Colors.black,
                          weight: FontWeight.bold,
                          size: 18,
                          spacing: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                MyText('----- or -----'),

                const SizedBox(height: 15),

                // error message
                (errorMessage.isNotEmpty)
                    ? Center(
                        child: MyText(
                          errorMessage,
                          size: 18,
                          color: Colors.red,
                          weight: FontWeight.bold,
                          spacing: 1,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 15),

                MyTextField(
                  controller: nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  label: 'E-mail',
                  hint: 'Enter your e-mail',
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Sign Up Button
                GestureDetector(
                  onTap: () async {
                    errorMessage = validate(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: emailController.text.trim(),
                    );
                    setState(() {});

                    if (errorMessage.isEmpty) {
                      var x = await helper.signUpWithCreds(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      );

                      if (x.runtimeType == String) {
                        errorMessage = x;
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
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
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: MyText(
                        'Sign Up',
                        weight: FontWeight.bold,
                        spacing: 2,
                        size: 25,
                      ),
                    ),
                  ),
                ),

                // Switch to register page
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText('Already a member?'),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: MyText(' Login!',
                          weight: FontWeight.bold, spacing: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validate(
      {required String name, required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) {
      return 'All fields are mandatory!';
    }
    return '';
  }
}
