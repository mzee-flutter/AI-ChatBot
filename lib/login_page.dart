import 'package:flutter/material.dart';
import 'package:chat_wave/google_signIn_services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_wave/shared_preferences_services.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GoogleSignInServices _googleSignInServices = GoogleSignInServices();
  final pref_services = SharedPreferencesServices();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? email;
  String? password;
  bool isSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
      ),
      body: ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white70,
          ),
          backgroundColor: Color(0xff424242),
        ),
        inAsyncCall: isSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'We are happy to have you back!',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    LogInPageTextField(
                      label: const Text(
                        'Email or Phone',
                      ),
                      onChange: (enterEmail) {
                        email = enterEmail;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    LogInPageTextField(
                      label: const Text('Password'),
                      onChange: (enterPassword) {
                        password = enterPassword;
                      },
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white24),
                        ),
                        const Spacer(),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6B59A3),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      height: 45,
                      color: const Color(0xff6B59A3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      onPressed: () async {
                        // emailController.clear();
                        // passwordController.clear();
                        setState(() {
                          isSpinner = true;
                        });
                        await pref_services.register(
                            context,
                            emailController.text.toString().trim(),
                            passwordController.text.toString().trim());
                        setState(() {
                          isSpinner = false;
                        });
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade700,
                            endIndent: 5,
                          ),
                        ),
                        const Text(
                          'Or',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade700,
                            indent: 5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isSpinner = true;
                            });
                            await _googleSignInServices
                                .signInWithGoogle(context);
                            setState(() {
                              isSpinner = false;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/google1.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              const Text(
                                'Sign In With Google',
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Don\'t have an account',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xff6B59A3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogInPageTextField extends StatelessWidget {
  final Widget label;
  final void Function(String)? onChange;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const LogInPageTextField({
    super.key,
    required this.label,
    required this.onChange,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChange,
        style: const TextStyle(
          color: Colors.white70,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade900,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 5),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade700, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          label: label,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
        ),
        cursorColor: Colors.white70,
      ),
    );
  }
}
