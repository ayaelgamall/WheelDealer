import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String uID = "fBDHfJIyBo908ecQdoaI";

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Drawer(
        child: ListView(children: [
      DrawerHeader(
        child: FutureBuilder<DocumentSnapshot>(
          future: UsersService().getUser(uID),
          builder: ((context, doc) {
            if (!doc.hasData ||
                doc.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ProfileAvatar(width: width / 5, height: height / 8),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doc.data!['display_name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("@${doc.data!['username']}",
                          style: TextStyle(color: Colors.white54, fontSize: 14))
                    ],
                  ),
                ],
              );
            }
          }),
        ),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {},
      ),
      ListTile(
        leading: Icon(Icons.logout_outlined),
        title: const Text('Logout'),
        onTap: () {},
      ),
    ]));
  }
}
