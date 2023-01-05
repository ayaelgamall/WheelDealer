// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bar2_banzeen/models/message.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/messaging_stream_service.dart';
import 'package:bar2_banzeen/services/notifications_service.dart';
import 'package:bar2_banzeen/services/sending_messages_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  String toUserId;
  String chatId;
  ChatScreen({super.key, required this.toUserId, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String thisUserId;
  TextEditingController textController = TextEditingController();

  Stream<QuerySnapshot> messages() {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  @override
  void initState() {
    thisUserId = AuthenticationService().getCurrentUser()!.uid;
    NotificationsService().registerNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 35,
          leading: IconButton(
              onPressed: (() {
                context.go("/mainPage/messages");
              }),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          title: FutureBuilder(
            future: SendingMessagesService()
                .fetchOtherUserId(widget.chatId, thisUserId),
            builder: (context, otherUserId) {
              if (!otherUserId.hasData) {
                return CircularProgressIndicator();
              }
              widget.toUserId = otherUserId.data!;
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: MessagingStreamService()
                      .getUser(widget.toUserId.toString()),
                  builder: (context, user) {
                    if (!user.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage((user
                                                .data?['profile_photo'] ==
                                            "" ||
                                        user.data?['profile_photo'] == null)
                                    ? "https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397"
                                    : user.data?['profile_photo']),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(user.data?['display_name']),
                      ],
                    );
                  });
            },
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
              return Column(
                children: [
                  Expanded(
                      child: GroupedListView<QueryDocumentSnapshot<Object?>,
                          DateTime>(
                    padding: EdgeInsets.all(8),
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    floatingHeader: true,
                    elements: messages.data!.docs,
                    groupBy: (msg) => DateTime(
                      ((msg['time'] as Timestamp).toDate()).year,
                      ((msg['time'] as Timestamp).toDate()).month,
                      ((msg['time'] as Timestamp).toDate()).day,
                    ),
                    groupHeaderBuilder: (QueryDocumentSnapshot<Object?> msg) =>
                        SizedBox(
                            height: 40,
                            child: Center(
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.amber.shade100,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      (msg['time'] as Timestamp).toDate().day ==
                                              DateTime.now().day
                                          ? "Today"
                                          : DateFormat.yMMMd().format(
                                              (msg['time'] as Timestamp)
                                                  .toDate()),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )),
                            )),
                    itemBuilder: (context, QueryDocumentSnapshot<Object?> msg) {
                      return Align(
                        alignment: msg['from'] == thisUserId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: msg['from'] == thisUserId
                              ? Color(0xFF02AEB9)
                              : Color(0xFF4C4C4E),
                          elevation: 8,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(msg['text']),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, bottom: 0),
                                      child: Text(
                                        DateFormat('hh:mm a').format(
                                            (msg['time'] as Timestamp)
                                                .toDate()),
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11),
                                      ),
                                    )
                                  ])),
                        ),
                      );
                    },
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 20, left: 20, right: 20),
                    child: TextField(
                      controller: textController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        contentPadding: EdgeInsets.all(12),
                        hintStyle: TextStyle(color: Colors.black54),
                        hintText: "Type your message...",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send_rounded),
                          color: Color.fromARGB(255, 37, 37, 38),
                          onPressed: () {
                            if (textController.text.isEmpty) return;
                            Message msg = Message(
                                from: thisUserId,
                                to: widget.toUserId.toString(),
                                text: textController.text,
                                time: Timestamp.now());
                            SendingMessagesService()
                                .sendMessage(msg, widget.chatId);
                            textController.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xFFF5F5F5)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xFFF5F5F5)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Color(0xFFF5F5F5)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                      ),
                      onSubmitted: (msgText) {
                        if (msgText.isEmpty) return;
                        Message msg = Message(
                            from: thisUserId,
                            to: widget.toUserId.toString(),
                            text: msgText,
                            time: Timestamp.now());
                        SendingMessagesService()
                            .sendMessage(msg, widget.chatId);
                        textController.clear();
                      },
                    ),
                  )
                ],
              );
            }));
  }
}
