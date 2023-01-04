import 'package:cloud_firestore/cloud_firestore.dart';

class MessagingStreamService {
  Stream<QuerySnapshot> getChats(String userId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .where('users', arrayContainsAny: [userId]).snapshots();
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
}
