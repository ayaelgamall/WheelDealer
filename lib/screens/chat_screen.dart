// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String ChatId = 'PgaDbmblSQzyKmBviEdP';
  String thisUserId = 'IKON6R95EWKMNeQbDemX';

  Stream<QuerySnapshot> messages() {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(ChatId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          leadingWidth: 95,
          title: Text('Ahmad Khaled'),
          leading: Row(
            children: [
              IconButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  icon: Icon(Icons.arrow_back_ios_new_outlined)),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://googleflutter.com/sample_image.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.info_outlined,
                color: Color(0xFFD2D2D8),
                size: 30,
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: messages(),
            builder: (context, messages) {
              if (!messages.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  itemBuilder: (itemContext, index) {
                    DateTime dateTime =
                        (messages.data!.docs[index]['time'] as Timestamp)
                            .toDate();
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: thisUserId == messages.data!.docs[index]['from']
                          ? Colors.blue.shade100
                          : Colors.grey.shade400,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            thisUserId == messages.data!.docs[index]['from']
                                ? "You: ${messages.data!.docs[index]['text']}"
                                : messages.data!.docs[index]['text'],
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        trailing: Text(
                          DateFormat('hh:mm a').format(dateTime),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    );
                  },
                  itemCount: messages.data!.docs.length);
            }));
  }
}
