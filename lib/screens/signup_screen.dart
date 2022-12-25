import 'dart:math';

import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/facebook_login_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/google_login_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static const routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _confirmPasswordTextController;

  bool _formHasErrors = true;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  SnackBar createSnackBar(String msg) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            msg,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade400,
    );
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            bool validEmail =
                EmailValidator.validate(_emailTextController.text);
            bool validPassword = _confirmPasswordTextController.text ==
                _passwordTextController.text;
            bool notEmptyPassword = _passwordTextController.text.isNotEmpty;
            updateError(!(validEmail && validPassword && notEmptyPassword));
          },
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) =>
                    SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      validator: (value) {
                        return EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email address";
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordTextController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: "Password"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTextController,
                      obscureText: true,
                      validator: (value) {
                        return value == _passwordTextController.text
                            ? null
                            : "Passwords are incompatible";
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Confirm Password"),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: !_formHasErrors
                            ? () async {
                                String? err = await AuthenticationService()
                                    .signUpWithEmail(_emailTextController.text,
                                        _passwordTextController.text);
                                if (err != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(createSnackBar(err));
                                }
                              }
                            : null,
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          //already handled in the theme
                          // backgroundColor: MaterialStateProperty.all<Color>(
                          //     !_formHasErrors
                          //         ? Theme.of(context).buttonColor
                          //         : Theme.of(context).unselectedWidgetColor),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        children: const [
                          Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR"),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 2,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const GoogleLoginButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    const FacebookLoginButton(),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        InkWell(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 183, 147, 0)),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          },
                        )
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
