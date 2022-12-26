// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:intl/intl.dart';
import 'package:bar2_banzeen/widgets/settings_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/messaging_stream_service.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF29292A),
        appBar: AppBar(
          title: Text('Messages'),
          leading: IconButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
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
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8B8B8B)),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                            hintStyle: TextStyle(
                              color: Color(0xFFF5F5F5),
                              height: 0.002,
                            ),
                            // prefixIcon: Icon(
                            //   Icons.search,
                            //   color: Color(0xFFF5F5F5),
                            // ),
                            hintText: 'Search Direct Messages',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFFF5F5F5)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90))),
                          ),
                          onSubmitted: (text) {},
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: MessagingStreamService().getChats(),
                    builder: (context, chats) {
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
                              return StreamBuilder<QuerySnapshot>(
                                  stream: MessagingStreamService()
                                      .getLastMessages(chatIds[index]),
                                  builder: (context, messages) {
                                    if (messages.hasData) {
                                      DateTime dateTime = (messages.data!.docs
                                              .first['time'] as Timestamp)
                                          .toDate();
                                      return ListTile(
                                        textColor: Colors.white,
                                        style: ListTileStyle.list,
                                        tileColor: Color(0xFF29292A),
                                        shape: Border(
                                          top: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8B8B8B)),
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8B8B8B)),
                                        ),
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
                                            stream: MessagingStreamService()
                                                .getUser(messages.data!.docs
                                                            .first['to'] ==
                                                        thisUserId
                                                    ? messages.data!.docs
                                                        .first['from']
                                                    : messages.data!.docs
                                                        .first['to']),
                                            builder: (context, user) {
                                              if (user.hasData) {
                                                return Text(
                                                  user.data!
                                                      .data()!['username'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                );
                                              } else {
                                                return Text("");
                                              }
                                            }),
                                        subtitle: Text(
                                          messages.data!.docs.first['from'] ==
                                                  thisUserId
                                              ? "You: ${messages.data!.docs.first['text'] ?? ''}"
                                              : messages
                                                  .data!.docs.first['text'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0XDEFFFFFF)),
                                        ),
                                        trailing: Text(
                                            DateFormat(MessagingStreamService()
                                                            .daysBetween(
                                                                dateTime,
                                                                DateTime
                                                                    .now()) >
                                                        1
                                                    ? 'MM/dd/yyyy'
                                                    : 'hh:mm a')
                                                .format(dateTime),
                                            style: TextStyle(
                                                color: Color(0xFF8B8B8B))),
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
