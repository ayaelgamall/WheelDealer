// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:bar2_banzeen/widgets/settings_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/chat_tile.dart';
import 'package:async/async.dart' show StreamGroup;

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  static const routeName = '/messaging';

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool isIntialized = false;
  bool isError = false;
  String thisUserId = "IKON6R95EWKMNeQbDemX";
  late Stream<List<ChatTile>> finalChatTilesStream;
  late Stream<List<ChatTile>> chatTilesStream;

  String formattedTime = DateFormat('kk:mm').format(DateTime.now());
  late Timer timer;

  void initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      // QuerySnapshot<Map<String, dynamic>> chatDocs = await FirebaseFirestore
      //     .instance
      //     .collection("chats")
      //     .where('users', arrayContainsAny: [thisUserId]).get();

      // List<Stream<List<ChatTile>>> streamList = [];
      // for (QueryDocumentSnapshot<Map<String, dynamic>> chatDoc
      //     in chatDocs.docs) {
      //   chatTilesStream = chatDocs.docs.first.reference
      //       .collection('messages')
      //       .orderBy("time", descending: true)
      //       .limit(1)
      //       .snapshots()
      //       .asyncMap((msgDocs) => Future.wait([
      //             for (var msgDoc in msgDocs.docs) generateUsersInChats(msgDoc)
      //           ]));
      //   streamList.add(chatTilesStream);
      // }
      // finalChatTilesStream = StreamGroup.merge(streamList);

      setState(() {
        isIntialized = true;
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  Stream<QuerySnapshot> getChats() {
    return FirebaseFirestore.instance
        .collection("chats")
        .where('users', arrayContainsAny: [thisUserId]).snapshots();
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

  // Future<ChatTile> generateUsersInChats(
  //     QueryDocumentSnapshot<Map<String, dynamic>> msgsDoc) async {
  //   Map<String, dynamic>? lastMsgData = msgsDoc.data();

  //   String userId = lastMsgData['to'] != thisUserId
  //       ? lastMsgData['to']
  //       : lastMsgData['from'];
  //   DocumentSnapshot<Map<String, dynamic>> userDoc =
  //       await FirebaseFirestore.instance.collection("users").doc(userId).get();
  //   Map<String, dynamic>? userData = userDoc.data();

  //   // QuerySnapshot<Map<String, dynamic>> msgsCol = await chatDoc.reference
  //   //     .collection("messages")
  //   //     .orderBy("time", descending: true)
  //   //     .get();
  //   // QueryDocumentSnapshot<Map<String, dynamic>> lastMsg = msgsCol.docs.first;
  //   // Map<String, dynamic>? lastMsgData = lastMsg.data();
  //   // print(lastMsgData);
  //   // //getting the user data
  //   // List usersIds = chatDoc.data()['users'];
  //   // String userId = usersIds[0] != thisUserId ? usersIds[0] : usersIds[1];
  //   // DocumentSnapshot<Map<String, dynamic>> userDoc =
  //   //     await FirebaseFirestore.instance.collection("users").doc(userId).get();
  //   // Map<String, dynamic>? userData = userDoc.data();
  //   // print(userData);

  //   return ChatTile(
  //       username: userData?['username'],
  //       profilePhotoLink: userData?['profile_photo'],
  //       lastMsgText: lastMsgData['text'],
  //       time: lastMsgData['time']);
  // }

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Messaging'),
          leading: IconButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          actions: [
            SettingsWidget(),
          ],
        ),
        body: isIntialized
            ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF29292A),
                      border: Border(
                        top: BorderSide(width: 0.5, color: Color(0xFFF5F5F5)),
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFFF5F5F5)),
                      ),
                    ),
                    child: Center(
                      child: IntrinsicWidth(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFFF5F5F5)),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFF5F5F5),
                            ),
                            hintText: 'Search Direct Messages',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90))),
                          ),
                          onChanged: (text) {
                            // print(users);
                          },
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: getChats(),
                    builder: (context, chats) {
                      print(chats.error.toString());
                      if (chats.connectionState == ConnectionState.waiting ||
                          !chats.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<String> chatIds = chats.data!.docs
                          .toList()
                          .map(
                            (e) => e.id,
                          )
                          .toList();
                      return Expanded(
                        child: SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemBuilder: (itemContext, index) {
                              // ChatTile chatTile = snapshot.data![index];
                              // timer = Timer.periodic(
                              //     const Duration(milliseconds: 500), (timer) {
                              //   setState(() {
                              //     formattedTime = DateFormat('kk:mm')
                              //         .format(DateTime.now());
                              //   });
                              // });
                              return StreamBuilder<QuerySnapshot>(
                                  stream: getLastMessages(chatIds[index]),
                                  builder: (context, messages) {
                                    if (messages.hasData) {
                                      return ListTile(
                                        textColor: Color.fromRGBO(0, 0, 0, 1),
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://googleflutter.com/sample_image.jpg'),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        title: StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: getUser(messages
                                                .data!.docs.first['to']),
                                            builder: (context, user) {
                                              if (user.hasData) {
                                                return Text(user.data!
                                                    .data()!['username']);
                                              } else {
                                                return Text("");
                                              }
                                            }),
                                        subtitle: Text(
                                            messages.data!.docs.first['text'] ??
                                                ''),
                                        trailing: Text(formattedTime),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            },
                            itemCount: chatIds.length,
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            : isError
                ? Center(
                    child: Text('Error'),
                  )
                : CircularProgressIndicator());
  }
}
