// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:bar2_banzeen/app_router.dart';
import 'package:bar2_banzeen/screens/edit_profile_screen.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bar2_banzeen/widgets/settings_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import '../services/messaging_stream_service.dart';
import '../services/notifications_service.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  // static const routeName = '/messaging';

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late String thisUserId;

  @override
  void initState() {
    thisUserId = AuthenticationService().getCurrentUser()!.uid;
    NotificationsService().registerNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Messages'),
          leading: IconButton(
              onPressed: (() {
                context.go('/mainPage');
              }),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
          // actions: [
          //   SettingsWidget(),
          // ],
        ),
        body: Column(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).backgroundColor,
            //     border: Border(
            //       bottom: BorderSide(width: 0.5, color: Color(0xFF8B8B8B)),
            //     ),
            //   ),
            //   child: Center(
            //       // child: Container(
            //       //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            //       //   child: TextField(
            //       //     style: TextStyle(color: Colors.white),
            //       //     textAlign: TextAlign.center,
            //       //     decoration: InputDecoration(
            //       //       contentPadding: EdgeInsets.only(top: 2, bottom: 2),
            //       //       hintStyle: TextStyle(
            //       //         color: Color(0xFFF5F5F5),
            //       //         height: 0.002,
            //       //       ),
            //       //       // prefixIcon: Icon(
            //       //       //   Icons.search,
            //       //       //   color: Color(0xFFF5F5F5),
            //       //       // ),
            //       //       hintText: 'Search Direct Messages',
            //       //       border: OutlineInputBorder(
            //       //           borderSide: BorderSide(width: 1, color: Color(0xFFF5F5F5)), borderRadius: BorderRadius.all(Radius.circular(90))),
            //       //       focusedBorder: OutlineInputBorder(
            //       //           borderSide: BorderSide(width: 1, color: Color(0xFFF5F5F5)), borderRadius: BorderRadius.all(Radius.circular(90))),
            //       //       enabledBorder: OutlineInputBorder(
            //       //           borderSide: BorderSide(width: 1, color: Color(0xFFF5F5F5)), borderRadius: BorderRadius.all(Radius.circular(90))),
            //       //     ),
            //       //     onSubmitted: (text) {},
            //       //   ),
            //       // ),
            //       ),
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: MessagingStreamService().getChats(thisUserId),
              builder: (context, chats) {
                print(thisUserId);
                print(chats.data!.docs.length);
                if (chats.data!.size == 0) {
                  return (Center());
                }
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
                              if (messages.data!.size == 0) {
                                return Container();
                              }
                              if (messages.hasData) {
                                String otherUserId =
                                    messages.data!.docs.first['to'] ==
                                            thisUserId
                                        ? messages.data!.docs.first['from']
                                        : messages.data!.docs.first['to'];
                                DateTime dateTime = (messages
                                        .data!.docs.first['time'] as Timestamp)
                                    .toDate();
                                return FutureBuilder(
                                    future:
                                        UsersService().fetchUser(otherUserId),
                                    builder: (context, user) {
                                      if (user.data == null) {
                                        return Center();
                                      }
                                      if (!user.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return InkWell(
                                        child: ListTile(
                                          textColor: Colors.white,
                                          style: ListTileStyle.list,
                                          tileColor:
                                              Theme.of(context).backgroundColor,
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
                                                  image: NetworkImage((user
                                                                  .data!
                                                                  .profilePhotoLink ==
                                                              null ||
                                                          user.data!
                                                                  .profilePhotoLink ==
                                                              "")
                                                      ? "https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397"
                                                      : user.data!
                                                              .profilePhotoLink ??
                                                          "https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397"),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          title: Text(
                                            user.data!.displayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          subtitle: Text(
                                            messages.data!.docs.first['from'] ==
                                                    thisUserId
                                                ? "You: ${messages.data!.docs.first['text'] ?? ''}"
                                                : messages
                                                    .data!.docs.first['text'],
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
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
                                        ),
                                        onTap: () {
                                          context.go(
                                              '/chat/$otherUserId/${chatIds[index]}');
                                        },
                                      );
                                    });
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
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
        ));
  }
}
