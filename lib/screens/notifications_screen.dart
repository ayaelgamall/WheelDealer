import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/notifications_service.dart';
import 'package:bar2_banzeen/widgets/drawer.dart';
import 'package:bar2_banzeen/widgets/notifications_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/messaging_stream_service.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthenticationService().getCurrentUser();

    return Scaffold(
      drawer: AppDrawer(
        location: 'notifications',
      ),
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {
              print(GoRouterState.of(context).location);
              context.go("/notifications/messages");
              // context.push("/messages");
            },
            icon: Icon(Icons.message),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: NotificationsService().getUserNotifications(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final notifications = snapshot.data!.docs;
              return ListView.separated(
                itemCount: notifications.isEmpty
                    ? 0
                    : notifications.length == 1
                        ? 2
                        : notifications.length + 2,
                separatorBuilder: (context, index) => index == 0 || index == 2
                    ? Container()
                    : const Divider(
                        thickness: 1,
                      ),
                itemBuilder: (context, index) => index == 0
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "New",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    : index == 2
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Earlier",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.background,
                            child: ListTile(
                              title: Text(notifications[
                                      index == 1 ? index - 1 : index - 2]
                                  .get('title')),
                              subtitle: Text(notifications[
                                      index == 1 ? index - 1 : index - 2]
                                  .get('body')),
                              leading: ClipOval(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(notifications[
                                                          index == 1
                                                              ? index - 1
                                                              : index - 2]
                                                      .get('photo') !=
                                                  null &&
                                              notifications[index == 1
                                                      ? index - 1
                                                      : index - 2]
                                                  .get('photo')
                                                  .toString()
                                                  .isNotEmpty
                                          ? notifications[index == 1
                                                  ? index - 1
                                                  : index - 2]
                                              .get('photo')
                                          : 'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397')),
                                ),
                              ),
                              trailing: Text(
                                  DateFormat(MessagingStreamService().daysBetween(
                                                  (notifications[index == 1
                                                                  ? index - 1
                                                                  : index - 2]
                                                              .get('time')
                                                          as Timestamp)
                                                      .toDate(),
                                                  DateTime.now()) >
                                              1
                                          ? 'MM/dd/yyyy'
                                          : 'hh:mm a')
                                      .format((notifications[index == 1
                                                  ? index - 1
                                                  : index - 2]
                                              .get('time') as Timestamp)
                                          .toDate()),
                                  style: const TextStyle(
                                      color: Color(0xFF8B8B8B))),
                            ),
                          ),
              );
            } else {
              return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: NotificationsShimmer());
            }
          }),
    );
  }
}
