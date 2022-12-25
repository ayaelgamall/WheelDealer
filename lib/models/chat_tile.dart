import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTile {
  String lastMsgText;
  Timestamp time;
  String profilePhotoLink;
  String username;
  ChatTile({
    required this.username,
    required this.profilePhotoLink,
    required this.lastMsgText,
    required this.time,
  });
}
