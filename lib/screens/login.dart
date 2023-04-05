import 'package:flutter/material.dart';
import 'package:pkeep_v2/commons.dart';
import 'package:pkeep_v2/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.showSignUpPage});
  final VoidCallback showSignUpPage;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final helper = Helper();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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

            // google login
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                print('dafuk');
                await helper.signInWithGoogle();
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
                      'Sign-in with Google',
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

            // E-mail textfield
            MyTextField(
              controller: emailController,
              label: 'E-mail',
              hint: 'Enter your e-mail',
            ),
            const SizedBox(height: 10),

            // Password textfield
            MyTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
            ),
            const SizedBox(height: 10),

            // Login Button
            GestureDetector(
              onTap: () async {
                errorMessage = validate(
                  email: emailController.text.trim(),
                  password: emailController.text.trim(),
                );
                setState(() {});

                if (errorMessage.isEmpty) {
                  var x = await helper.signInWithEmailAndPassword(
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
                  color: const Color.fromARGB(255, 135, 53, 149),
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: MyText(
                    'Login',
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
                MyText('Not registered yet?'),
                GestureDetector(
                  onTap: widget.showSignUpPage,
                  child:
                      MyText(' Sign up!', weight: FontWeight.bold, spacing: 1),
                ),
              ],
            ),

            // Forgot password
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: MyText('Forgot password?',
                  weight: FontWeight.bold, spacing: 1),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String validate({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) {
      return 'All fields are mandatory!';
    }
    return '';
  }
}
