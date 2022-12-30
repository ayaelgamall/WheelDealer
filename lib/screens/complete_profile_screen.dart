import 'dart:io';

import 'package:bar2_banzeen/models/user.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
  static const routeName = '/complete_profile';

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  XFile? _profile_photo;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  bool _enableSubmit = false;
  bool _imageLoading = false;
  bool _addingUser = false;

  void updateSubmitEnable() {
    setState(() {
      _enableSubmit =
          _formKey.currentState != null && _formKey.currentState!.validate();
    });
  }

  Future getProfilePhoto() async {
    setState(() {
      _imageLoading = true;
    });
    XFile? profilePhoto = await picker.pickImage(source: ImageSource.gallery);
    if (profilePhoto != null) {
      setState(() {
        _profile_photo = profilePhoto;
      });
    }
    setState(() {
      _imageLoading = false;
    });
  }

  @override
  void dispose() {
    _displayName.dispose();
    _username.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          updateSubmitEnable();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: InkWell(
                          child: ClipOval(
                            child: _imageLoading
                                ? (Platform.isAndroid
                                    ? const CircularProgressIndicator()
                                    : const CupertinoActivityIndicator())
                                : (_profile_photo != null
                                    ? Image.file(
                                        File(_profile_photo!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'lib/assets/images/icons/userIcon.png')),
                          ),
                          onTap: () {
                            getProfilePhoto();
                          },
                        ),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(Icons.camera_alt),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
                    hintText: "Username",
                  ),
                  controller: _username,
                  validator: (value) => value != null &&
                          !value.contains(' ') &&
                          value.toLowerCase() == value &&
                          !value.startsWith(RegExp(r'[0-9]')) &&
                          value.isNotEmpty
                      ? null
                      : "Please enter a valid username",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Display Name",
                    prefixIcon: Icon(Icons.abc),
                  ),
                  controller: _displayName,
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Display Name must not be empty",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                  ),
                  controller: _phoneNumber,
                  validator: (value) => value != null &&
                          value.isNotEmpty &&
                          RegExp(r'^((\+?20)|0)?(1[0125][123456789])\d{7}$')
                              .hasMatch(value)
                      ? null
                      : "Please enter a valid phone number",
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 220,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _enableSubmit && !_addingUser
                        ? () async {
                            setState(() {
                              _addingUser = true;
                            });
                            UserModel addedUser = UserModel(
                              uid: user!.uid,
                              email: user.email ?? "",
                              displayName: _displayName.text,
                              username: _username.text,
                              phoneNumber: _phoneNumber.text,
                              localPhoto: _profile_photo,
                            );
                            await UsersService().addUser(addedUser);
                            if (mounted) {
                              setState(() {
                                _addingUser = false;
                              });
                            }
                          }
                        : null,
                    child: _addingUser
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Finish Sign Up",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
