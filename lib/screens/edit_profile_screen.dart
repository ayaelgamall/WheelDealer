import 'dart:io';

import 'package:bar2_banzeen/models/user.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../services/storage_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

// int _descriptionLength = 0;

// String _photosError = "";

// bool _enableSubmit = false;
// bool _addingCar = false;
// String userPhotoLink =
//     'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397';

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  XFile? _localPhoto;
  bool _formHasErrors = true;
  final ImagePicker picker = ImagePicker();

  bool _dataLoading = false;
  bool _photosLoading = false;
  bool _updatingUser = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    setState(() {
      _dataLoading = true;
    });
    final curretUser = AuthenticationService().getCurrentUser();
    String userId = curretUser!.uid;
    final userDoc = await UsersService().getUser(userId);
    Map<String, dynamic> map = userDoc.data() as Map<String, dynamic>;

    final imageRes = await http.get(Uri.parse(map['profile_photo']));
    final directory = await getTemporaryDirectory();
    final file = File(join(directory.path, "$userId.jpg"));
    file.writeAsBytesSync(imageRes.bodyBytes);
    XFile localPhoto = XFile(file.path);
    _emailTextController.text = map['email'];
    _usernameTextController.text = map['username'];
    _nameTextController.text = map['display_name'];
    _phoneTextController.text = map['phone_number'];
    _localPhoto = localPhoto;
    setState(() {
      _dataLoading = false;
    });
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
  }

  Future getImage() async {
    setState(() {
      _photosLoading = true;
    });

    XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photosLoading = false;
      _localPhoto = photo;
    });
  }

  SnackBar successSnackBar() {
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
            constraints: const BoxConstraints(maxWidth: 460),
            child: const Text(
              "Profile Updated Successfully",
              maxLines: 2,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
    );
  }

  // void deleteImage(XFile? img) {
  //   setState(() {
  //     _localPhoto = XFile('/lib/assets/images/icons/userIcon.png');
  //   });
  // }

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
            constraints: const BoxConstraints(maxWidth: 460),
            child: Text(
              msg,
              maxLines: 2,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      // backgroundColor: Colors.red.shade460,
    );
  }

  bool validateMobile(String value) {
    String pattern = r'(^(?:[+2])?[0-9]{12,12}$)';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final curretUser = Provider.of<User?>(context);
    String userId = curretUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: _dataLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () {
                bool validEmail =
                    EmailValidator.validate(_emailTextController.text);
                bool notEmptyUsername = _usernameTextController.text.isNotEmpty;
                bool notEmptyName = _nameTextController.text.isNotEmpty;
                updateError(!(validEmail && notEmptyUsername & notEmptyName));
              },
              child: SizedBox(
                width: 500,
                height: 900,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: 340,
                          height: 900,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 150,
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: _photosLoading
                                          ? null
                                          : () {
                                              getImage();
                                            },
                                      child: _photosLoading
                                          ? SizedBox(
                                              width: 130,
                                              height: 130,
                                              child: Center(
                                                child: Platform.isAndroid
                                                    ? const CircularProgressIndicator()
                                                    : const CupertinoActivityIndicator(),
                                              ),
                                            )
                                          : Container(
                                              height: 130,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      _localPhoto!.path),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const Positioned(
                                      bottom: 4,
                                      right: 20,
                                      child: Icon(Icons.camera_alt),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 420,
                                height: 700,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 400,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  width: 290,
                                                  height: 45,
                                                  child: TextFormField(
                                                    controller:
                                                        _nameTextController,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(), // TODO make this line override theme
                                                    ),
                                                  ))
                                            ])),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.mail),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 290,
                                            height: 45,
                                            child: TextFormField(
                                              controller: _emailTextController,
                                              validator: (value) => EmailValidator
                                                      .validate(value!)
                                                  ? null
                                                  : "Please enter a valid email address",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 114, 112, 112)),
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                border:
                                                    UnderlineInputBorder(), // TODO make this line override theme
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 25,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              child: Image.asset(
                                                  'lib/assets/images/icons/username.png'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 290,
                                            height: 45,
                                            child: TextFormField(
                                              controller:
                                                  _usernameTextController,
                                              decoration: const InputDecoration(
                                                border:
                                                    UnderlineInputBorder(), // TODO make this line override theme
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.phone),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 290,
                                            height: 45,
                                            child: TextFormField(
                                              controller: _phoneTextController,
                                              validator: (value) => validateMobile(
                                                      value!)
                                                  ? null
                                                  : "Please enter a valid Egyptian phone number",
                                              decoration: const InputDecoration(
                                                border:
                                                    UnderlineInputBorder(), // TODO make this line override theme
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 170,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: _updatingUser
                                            ? null
                                            : !_formHasErrors
                                                ? () async {
                                                    setState(() {
                                                      _updatingUser = true;
                                                    });
                                                    UserModel user = UserModel(
                                                        uid: userId,
                                                        email:
                                                            _emailTextController
                                                                .text,
                                                        displayName:
                                                            _nameTextController
                                                                .text,
                                                        username:
                                                            _usernameTextController
                                                                .text,
                                                        phoneNumber:
                                                            _phoneTextController
                                                                .text,
                                                        // profilePhotoLink: userPhotoLink,
                                                        localPhoto:
                                                            _localPhoto);
                                                    await UsersService()
                                                        .addUser(user);

                                                    context.go('/profile');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            successSnackBar());
                                                  }
                                                : null,
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                        child: _updatingUser
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const Text(
                                                "Update Profile",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
