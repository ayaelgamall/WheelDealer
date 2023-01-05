import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/authentication_service.dart';

class AppDrawer extends StatelessWidget {
  String location;
  AppDrawer({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final userData = AuthenticationService().getCurrentUser();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
        child: FutureBuilder<DocumentSnapshot>(
          future: UsersService().getUser(userData!.uid),
          builder: ((context, user) {
            if (!user.hasData ||
                user.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ProfileAvatar(
                      width: width / 5,
                      height: height / 8,
                      photoURL: user.data!.get('profile_photo') != null &&
                              (user.data!.get('profile_photo') as String)
                                  .isNotEmpty
                          ? user.data!.get('profile_photo')
                          : 'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397',
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.data!['display_name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("@${user.data!['username']}",
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14))
                    ],
                  ),
                ],
              );
            }
          }),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          context.go('/${location}/settings');
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout_outlined),
        title: Text('Logout'),
        onTap: () {
          AuthenticationService().signOut();

          context.go('/wrapper');
        },
      ),
    ]));
  }
}
