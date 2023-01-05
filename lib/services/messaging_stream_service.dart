import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MessagingStreamService {
  Stream<QuerySnapshot> getChats(String userId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .where('user0', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<String> getChatId(userId1, userId2) async {
    QuerySnapshot<Map<String, dynamic>> chatDoc1 = await FirebaseFirestore
        .instance
        .collection("chats")
        .where("user0", isEqualTo: userId1)
        .where("user1", isEqualTo: userId2)
        .get();

    QuerySnapshot<Map<String, dynamic>> chatDoc2 = await FirebaseFirestore
        .instance
        .collection("chats")
        .where("user0", isEqualTo: userId2)
        .where("user1", isEqualTo: userId1)
        .get();
    if (chatDoc1.docs.isNotEmpty) {
      return chatDoc1.docs.first.id;
    } else {
      if ((chatDoc2.docs.isNotEmpty)) {
        return chatDoc2.docs.first.id;
      } else {
        DocumentReference<Map<String, dynamic>> chatDocRef =
            await FirebaseFirestore.instance.collection("chats").add({
          "user0": userId1,
          "user1": userId2,
          "users": [userId1, userId2]
        });

        final batch = FirebaseFirestore.instance.batch();
        DocumentReference<Map<String, dynamic>> userDoc1 =
            await FirebaseFirestore.instance.collection("users").doc(userId1);
        DocumentReference<Map<String, dynamic>> userDoc2 =
            await FirebaseFirestore.instance.collection("users").doc(userId2);

        batch.update(userDoc1, {
          "chats": FieldValue.arrayUnion([chatDocRef.id])
        });
        batch.update(userDoc2, {
          "chats": FieldValue.arrayUnion([chatDocRef.id])
        });
        await batch.commit();

        return chatDocRef.id;
      }
    }
  }
}
