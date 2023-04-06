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
              onTap: () async {
                final resetEmailController = TextEditingController();
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
                                MyText("Enter your registered E-mail",
                                    size: 18),
                                const SizedBox(width: 15),
                                MyText(
                                  'We\'ll send you an E-mail to reset your password',
                                  size: 14,
                                ),
                                const SizedBox(height: 15),

                                // e-mail text field
                                MyTextField(
                                  controller: resetEmailController,
                                  label: 'E-mail',
                                  hint: 'Enter registered E-mail',
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // cancel button
                                    GestureDetector(
                                      onTap: () {
                                        resetEmailController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: MyText(
                                        'Cancel',
                                        weight: FontWeight.bold,
                                        spacing: 1,
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    // resend e-mail button
                                    TextButton(
                                      onPressed: () async {
                                        await helper.resetPassword(
                                          email:
                                              resetEmailController.text.trim(),
                                        );

                                        resetEmailController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: MyText(
                                        'Send Reset E-mail',
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
