import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _emailTextController;
  late TextEditingController _usernameTextController;
  late TextEditingController _nameTextController;
  late TextEditingController _phoneTextController;

  bool _formHasErrors = true;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _usernameTextController = TextEditingController();
    _nameTextController = TextEditingController();
    _phoneTextController= TextEditingController();
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
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
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade400,
    );
  }

  bool validateMobile(String value) {
    String pattern = r'(^(?:[+2])?[0-9]{12,12}$)';
    RegExp regExp = new RegExp(pattern);
   return regExp.hasMatch(value);
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
                  bool notEmptyUsername =
                      _usernameTextController.text.isNotEmpty;
                  bool notEmptyName = _nameTextController.text.isNotEmpty;
                  updateError(!(validEmail && notEmptyUsername & notEmptyName));
                },
                child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text("name          "),
                        Container(
                            padding: const EdgeInsets.all(5),
                            width: 270,
                            height: 45,
                            child: TextFormField(
                              controller: _nameTextController,
                              decoration: const InputDecoration(
                                  border:
                                      UnderlineInputBorder(), // TODO make this line override theme
                                  hintText: "My current name"),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text("email         "),
                        Container(
                            padding: const EdgeInsets.all(5),
                            width: 270,
                            height: 45,
                            child: TextFormField(
                              controller: _emailTextController,
                              validator: (value) =>
                                  EmailValidator.validate(value!)
                                      ? null
                                      : "Please enter a valid email address",
                              decoration: const InputDecoration(
                                border:
                                    UnderlineInputBorder(), // TODO make this line override theme
                                hintText: "Mycurrent@email.com",
                              ),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text("username "),
                        Container(
                            padding: const EdgeInsets.all(5),
                            width: 270,
                            height: 45,
                            child: TextFormField(
                              controller: _usernameTextController,
                              decoration: const InputDecoration(
                                  border:
                                      UnderlineInputBorder(), // TODO make this line override theme
                                  hintText: "@username"),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text("phone no. "),
                        Container(
                            padding: const EdgeInsets.all(5),
                            width: 270,
                            height: 45,
                            child: TextFormField(
                              controller: _phoneTextController,
                              validator: (value) =>
                                  validateMobile(value!)
                                      ? null
                                      : "Please enter a valid Egyptian phone number",
                              decoration: const InputDecoration(
                                border:
                                    UnderlineInputBorder(), // TODO make this line override theme
                                hintText: "+201234567890",
                              ),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 170,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: !_formHasErrors
                              ? () async {
                                  // UPDATE DB
                                  // String? err = await AuthenticationService()
                                  //     .signInWithEmail(_emailTextController.text,
                                  //         _passwordTextController.text);
                                  // if (err != null) {
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(createSnackBar(err));
                                  // }
                                }
                              : null,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ])))));
  }
}
