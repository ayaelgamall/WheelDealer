import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/users_service.dart';

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
  late TextEditingController _emailTextController;
  late TextEditingController _usernameTextController;
  late TextEditingController _nameTextController;
  late TextEditingController _phoneTextController;
  XFile? _photo = XFile('/lib/assets/images/icons/userIcon.png');
  bool _formHasErrors = true;
  final ImagePicker picker = ImagePicker();
  var userId = "IKON6R95EWKMNeQbDemX";
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      _emailTextController = TextEditingController(text: map['email']);
      _usernameTextController = TextEditingController(text: map['username']);
      _nameTextController = TextEditingController(text: map['display_name']);
      _phoneTextController = TextEditingController(text: map['phone_number']);
      userPhotoLink = map['profile_photo'];
    });
    super.initState();
  }

  void updateError(bool err) {
    setState(() {
      _formHasErrors = err;
    });
  }

  Future getImages() async {
    try {
      setState(() {
        _photosLoading = true;
      });
      XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
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
            child: Column(children: [
              Container(
                width: 150,
                child: Image.network(userPhotoLink),
              ),
              InkWell(
                onTap: !_addingCar
                    ? () {
                        getImages();
                      }
                    : null,
                child: Container(
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 230,
                      ),
                      Icon(
                        Icons.edit,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () {
                    bool validEmail =
                        EmailValidator.validate(_emailTextController.text);
                    bool notEmptyUsername =
                        _usernameTextController.text.isNotEmpty;
                    bool notEmptyName = _nameTextController.text.isNotEmpty;
                    updateError(
                        !(validEmail && notEmptyUsername & notEmptyName));
                  },
                  child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 260,
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.mail),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 260,
                                  height: 45,
                                  child: TextFormField(
                                    controller: _emailTextController,
                                    validator: (value) => EmailValidator
                                            .validate(value!)
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 30,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: Image.asset(
                                          'lib/assets/images/icons/username.png'))),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 260,
                                  height: 45,
                                  child: TextFormField(
                                    controller: _usernameTextController,
                                    decoration: const InputDecoration(
                                        border:
                                            UnderlineInputBorder(), // TODO make this line override theme
                                        hintText: "username"),
                                  ))
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 260,
                                  height: 45,
                                  child: TextFormField(
                                    controller: _phoneTextController,
                                    validator: (value) => validateMobile(value!)
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
                      ])))
            ])));
  }
}
