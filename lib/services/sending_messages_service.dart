import 'package:bar2_banzeen/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendingMessagesService {
  void sendMessage(Message msg, String chatId) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
      "from": msg.from,
      "to": msg.to,
      "text": msg.text,
      "time": msg.time
    });
  }

  Future<String> fetchOtherUserId(String chatId, String userId) async {
    // FirebaseFirestore.instance
    //     .collection("chats")
    //     .doc(chatId)
    //     .get()
    //     .then((chatDoc) {
    //   List usersIds = chatDoc.data()?['users'];
    //   return userId == usersIds[0] ? usersIds[1] : usersIds[0];
    // });
    DocumentSnapshot<Map<String, dynamic>> chatDoc =
        await FirebaseFirestore.instance.collection("chats").doc(chatId).get();

    List usersIds = chatDoc.data()?['users'];
    return userId == usersIds[0] ? usersIds[1] : usersIds[0];
  }
}
