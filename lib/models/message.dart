import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String to;
  String text;
  Timestamp time;

  Message(
      {required this.from,
      required this.to,
      required this.text,
      required this.time});
}
