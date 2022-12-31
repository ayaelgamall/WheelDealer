import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class UsersService {
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection("users");
  final String defaultPhoto = "";
  
  Future<void> addUser(UserModel user) async {
    String? profilePhotoLink = user.localPhoto != null
        ? await StorageService().uploadUserPhoto(user.uid, user.localPhoto!)
        : null;
    await _usersReference.doc(user.uid).set({
      "email": user.email,
      "display_name": user.displayName,
      "username": user.username,
      "phone_number": user.phoneNumber,
      "profile_photo": profilePhotoLink,
      "posted_cars": [],
    });
  }

  Stream<DocumentSnapshot> isUserProfileComplete(String userId) {
    return _usersReference.doc(userId).snapshots();
  }
}
