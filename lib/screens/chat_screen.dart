// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String ChatId = 'PgaDbmblSQzyKmBviEdP';

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
                    return ListTile(
                        title: Text(messages.data!.docs[index]['text']));
                  },
                  itemCount: messages.data!.docs.length);
            }));
  }
}
