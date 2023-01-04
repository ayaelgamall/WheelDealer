import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class UsersService {
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection("users");
  final String defaultPhoto = "";

  Future<void> deleteUserBid(String carID, String userID) async {
    await _usersReference
        .doc(userID)
        .collection("bids")
        .where("car", isEqualTo: carID)
        .get()
        .then((querySnapshot) {
      _usersReference
          .doc(userID)
          .collection("bids")
          .doc(querySnapshot.docs.first.id)
          .delete();
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> deleteUserPost(String carID, String userID) async {
    await _usersReference
        .doc(userID)
        .collection("bids")
        .where("car", isEqualTo: carID)
        .get()
        .then((querySnapshot) {
      _usersReference.doc(userID).update({
        "posted_cars": FieldValue.arrayRemove([carID])
      });
    }).catchError((err) {
      print(err);
    });
  }

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
      "favs": [],
    });
  }

  Future<void> addToFavs(String uid, String car) async {
    await _usersReference.doc(uid).update({
      "favs": FieldValue.arrayUnion([car])
    });
  }

  Future<void> removeFromFavs(String uid, String car) async {
    await _usersReference.doc(uid).update({
      "favs": FieldValue.arrayRemove([car])
    });
  }

  Stream<DocumentSnapshot> isUserProfileComplete(String userId) {
    return _usersReference.doc(userId).snapshots();
  
  Future<DocumentSnapshot> getUser(String userID) {
    return _usersReference.doc(userID).get();
  }

  Future<void> updateUserToken(String token) async {
    String userId = AuthenticationService().getCurrentUser()!.uid;
    await _usersReference.doc(userId).update({"fcm_token": token});
  }
}
