import 'package:image_picker/image_picker.dart';

class UserModel {
  String uid;
  String username;
  String displayName;
  String phoneNumber;
  String email;
  String? profilePhotoLink;
  XFile? localPhoto;

  UserModel(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.username,
      required this.phoneNumber,
      this.profilePhotoLink,
      this.localPhoto});
}
