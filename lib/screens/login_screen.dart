import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/facebook_login_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../widgets/google_login_button.dart';

class LoginScreen extends StatefulWidget {
  Function switchFunction;
  LoginScreen(this.switchFunction, {Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  bool _formHasErrors = true;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              msg,
              maxLines: 2,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade400,
    );
  }

  SnackBar resetPasswordSnackBar() {
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: const Text(
              "Password reset instructions has been sent to your email",
              maxLines: 2,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade400,
    );
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: () {
            bool validEmail =
                EmailValidator.validate(_emailTextController.text);
            bool notEmptyPassword = _passwordTextController.text.isNotEmpty;
            updateError(!(validEmail && notEmptyPassword));
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
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email address",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: EmailValidator.validate(
                                  _emailTextController.text)
                              ? () async {
                                  String? err = await AuthenticationService()
                                      .resetPassword(_emailTextController.text);
                                  if (err != null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(createSnackBar(err));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(resetPasswordSnackBar());
                                  }
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      createSnackBar(
                                          "Please enter a valid email address first"));
                                },
                          child: const Text(
                            "Forgot your password?",
                          ),
                        )
                      ],
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
                                    .signInWithEmail(_emailTextController.text,
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
                          // backgroundColor: MaterialStateProperty.all<Color>(
                          //     !_formHasErrors
                          //         ? Theme.of(context).buttonColor
                          //         : Theme.of(context).unselectedWidgetColor),
                        ),
                        child: const Text(
                          "Login",
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
                        const Text("Don't have an account? "),
                        InkWell(
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Color.fromARGB(255, 183, 147,
                                    0)), //TODO Cannot make it as the theme requires constant
                          ),
                          onTap: () {
                            widget.switchFunction();
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
