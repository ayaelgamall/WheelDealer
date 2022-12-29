import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UsersService {
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection("users");
  final String defaultPhoto = "";
  Future<void> addCar(String phone, String username, String email, String name,
      XFile profilePhoto, String userId) async {
    bool exists = await userExists(userId);
    if (exists) {
      _usersReference.doc(userId).update({
        "email": email,
        "phone_number": phone,
        "username": username,
        "display_name": name
      });
    } else {
      DocumentReference carDocument = await _usersReference.add({
        "email": email,
        "phone_number": phone,
        "username": username,
        "profile_photo": defaultPhoto,
        "display_name": name
      });

      String uploadedPhoto =
          await StorageService().uploadUserPhoto(userId, profilePhoto);
      await _usersReference
          .doc(userId)
          .update({"profile_photo": uploadedPhoto});
    }
  }
}

Future<bool> userExists(String docId) async {
  try {
    final CollectionReference _usersReference =
        FirebaseFirestore.instance.collection("users");

    var doc = await _usersReference.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}

DocumentReference<Map<String, dynamic>> getUserData(String userId) {
  return FirebaseFirestore.instance.collection("users").doc(userId);
}
