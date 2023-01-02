import 'package:bar2_banzeen/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bar2_banzeen/services/users_service.dart';

import '../services/storage_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

int _descriptionLength = 0;

String _photosError = "";

bool _photosLoading = false;
bool _enableSubmit = false;
bool _addingCar = false;
String userPhotoLink =
    'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397';

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _emailTextController = TextEditingController();
  late TextEditingController _usernameTextController = TextEditingController();
  late TextEditingController _nameTextController = TextEditingController();
  late TextEditingController _phoneTextController = TextEditingController();
  XFile? _photo = XFile('/lib/assets/images/icons/userIcon.png');
  bool _formHasErrors = true;
  final ImagePicker picker = ImagePicker();
  var userId = "IQ8O7SsY85NmhVQwghef7RF966z1"; //TODO change userID
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _emailTextController = TextEditingController(text: map['email']);
        _usernameTextController = TextEditingController(text: map['username']);
        _nameTextController = TextEditingController(text: map['display_name']);
        _phoneTextController = TextEditingController(text: map['phone_number']);
        userPhotoLink = map['profile_photo'];
      });
    });
    super.initState();
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
  }

  Future getImage() async {
    try {
      setState(() {
        _photosLoading = true;
      });
      XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      String link = await StorageService().uploadUserPhoto(userId, photo!);
      setState(() {
        userPhotoLink = link;
        _photosLoading = false;
        _photo = photo;
        _photosError = "";
      });
      // updateSubmitEnable();
    } catch (_) {
      setState(() {
        _photosError = "Error in Adding Photos!";
      });
    }
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

  void deleteImage(XFile? img) {
    setState(() {
      _photo = XFile('/lib/assets/images/icons/userIcon.png');
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
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
        ),
        body: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              bool validEmail =
                  EmailValidator.validate(_emailTextController.text);
              bool notEmptyUsername = _usernameTextController.text.isNotEmpty;
              bool notEmptyName = _nameTextController.text.isNotEmpty;
              updateError(!(validEmail && notEmptyUsername & notEmptyName));
            },
            child: Container(
                width: 500,
                height: 900,
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                              width: 340,
                              height: 900,
                              child: Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: 150,
                                    child: Stack(
                                      children: [
                                        Container(
                                            height: 130,
                                            width: 130,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        userPhotoLink)))),
                                        Positioned(
                                          bottom: 4,
                                          right: 20,
                                          child: InkWell(
                                              child: Icon(Icons.camera_alt),
                                              onTap: () => getImage()),
                                        )
                                      ],
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: 420,
                                    height: 700,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 400,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.person),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
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
                                          Container(
                                              width: 400,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.mail),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        width: 290,
                                                        height: 45,
                                                        child: TextFormField(
                                                          controller:
                                                              _emailTextController,
                                                          validator: (value) =>
                                                              EmailValidator
                                                                      .validate(
                                                                          value!)
                                                                  ? null
                                                                  : "Please enter a valid email address",
                                                          style:
                                                              const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          114,
                                                                          112,
                                                                          112)),
                                                          readOnly: true,
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
                                          Container(
                                              width: 400,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 25,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.0),
                                                            child: Image.asset(
                                                                'lib/assets/images/icons/username.png'))),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        width: 290,
                                                        height: 45,
                                                        child: TextFormField(
                                                          controller:
                                                              _usernameTextController,
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
                                          Container(
                                              width: 400,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.phone),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        width: 290,
                                                        height: 45,
                                                        child: TextFormField(
                                                          controller:
                                                              _phoneTextController,
                                                          validator: (value) =>
                                                              validateMobile(
                                                                      value!)
                                                                  ? null
                                                                  : "Please enter a valid Egyptian phone number",
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
                                            width: 170,
                                            height: 45,
                                            child: ElevatedButton(
                                              onPressed: !_formHasErrors
                                                  ? () async {
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
                                                          profilePhotoLink:
                                                              userPhotoLink,
                                                          localPhoto: _photo);
                                                      await UsersService()
                                                          .addUser(user);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              successSnackBar());
                                                    }
                                                  : null,
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                "Update Profile",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ),
                                          ),
                                        ]))
                              ]))))
                ]))));
  }
}
