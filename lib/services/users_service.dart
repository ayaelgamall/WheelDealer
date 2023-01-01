import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/Car.dart';

class UsersService {
  final CollectionReference _usersReference =
      FirebaseFirestore.instance.collection("users");

  Future<void> delteUserBid(String carID, String userID) async {
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

  Future<void> delteUserPost(String carID, String userID) async {
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

  Future<void> getUser(String userID) async {
    // (_usersReference.doc().data!.data()!["posted_cars"])
    //               : (userData.collection("bids"));
    _usersReference.doc(userID);
  }
}
