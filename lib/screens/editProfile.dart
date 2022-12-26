import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  bool _formHasErrors = true;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _usernameTextController = TextEditingController();
    _nameTextController = TextEditingController();
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
                        Container(padding: const EdgeInsets.all(5),
                            width: 270,
                            child: TextFormField(
                              controller: _nameTextController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "name"),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        const Text("email         "),
                        Container(padding: const EdgeInsets.all(5),
                            width: 270,
                            child: TextFormField(
                              controller: _emailTextController,
                              validator: (value) =>
                                  EmailValidator.validate(value!)
                                      ? null
                                      : "Please enter a valid email address",
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "email",
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
                            child: TextFormField(
                              controller: _usernameTextController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "username"),
                            ))
                      ]),
                      const SizedBox(
                        height: 20,
                      )
                    ])))));
  }
}
