import 'package:bar2_banzeen/widgets/app_bar.dart';
import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:bar2_banzeen/widgets/profile_bids.dart';
import 'package:bar2_banzeen/widgets/profile_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const routeName = '/profile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _tabsNames = [
    const Text(
      "My posts",
    ),
    const Text("My bids")
  ];
  final List<bool> _selectedTab1 = <bool>[true];
  final List<bool> _selectedTab2 = <bool>[false];

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);
    final userData = AuthenticationService().getCurrentUser();
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc("fBDHfJIyBo908ecQdoaI");

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(),//todo change
        appBar: CustomAppBar(),
        body: FutureBuilder<DocumentSnapshot>(
          future: UsersService().getUser(userData!.uid),
          builder: ((context, user) {
            if (user.hasData) {
              final carsToShow = _selectedTab1[0]
                  ? (user.data!.get('posted_cars'))
                  : (UsersService().getUserBids(userData.uid));
              return ListView(children: [
                Container(
                  height: 0.4 * height,
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.white12, //TODO add based on theme
                    ),
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ProfileAvatar(
                          width: 0.45 * width,
                          height: 0.2 * height,
                          photoURL: user.data!.get('profile_photo') != null &&
                                  (user.data!.get('profile_photo') as String)
                                      .isNotEmpty
                              ? user.data!.get('profile_photo')
                              : 'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397',
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        user.data!.get('display_name'),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text("@${user.data!.get('username')}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white54)),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(120, 30))),
                            onPressed: () {
                              context.go('/profile/editProfile');
                            },
                            child: const Text("Edit Profile"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(40, 30))),
                            child: const Icon(
                              size: 18,
                              Icons.settings_outlined,
                            ),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToggleButtons(
                      isSelected: _selectedTab1,
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          _selectedTab1[0] = true;
                          _selectedTab2[0] = false;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      constraints: const BoxConstraints(
                        minHeight: 30.0,
                        minWidth: 120.0,
                      ),
                      children: [_tabsNames[0]],
                    ),
                    ToggleButtons(
                      isSelected: _selectedTab2,
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          _selectedTab2[0] = true;
                          _selectedTab1[0] = false;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      constraints: const BoxConstraints(
                        minHeight: 30.0,
                        minWidth: 120.0,
                      ),
                      children: [_tabsNames[1]],
                    ),
                  ],
                ),
                _selectedTab1[0]
                    ? ProfilePosts(
                        carsToShow: carsToShow,
                        height: height,
                        width: width,
                        ctx: context)
                    : ProfileBids(
                        height: height,
                        width: width,
                        carsToShow: carsToShow,
                        ctx: context),
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
