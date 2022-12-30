import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:bar2_banzeen/widgets/profile_cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/car_card.dart';
import '../widgets/horizontal_cars.dart';
import '../widgets/main_page_heading.dart';
import '../widgets/view_more_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const routeName = '/profile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _tabsNames = [
    Text(
      "My posts",
    ),
    Text("My bids")
  ];
  final List<bool> _selectedTab1 = <bool>[true];
  final List<bool> _selectedTab2 = <bool>[false];

  @override
  Widget build(BuildContext context) {
    final cars = FirebaseFirestore.instance.collection('cars');
    final carsToShow = _selectedTab1[0]
        ? cars.orderBy("bids_count")
        : cars.orderBy("creation_time");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("beebbeeb")),
      body: ListView(children: [
        Container(
          height: 0.4 * height,
          decoration: BoxDecoration(
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
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                "Gego Elbadrawy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text("@Gego",
                  style: TextStyle(fontSize: 14, color: Colors.white54)),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(120, 30))),
                    onPressed: () {},
                    child: Text("Edit profile"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(40, 30))),
                    child: Icon(
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
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ToggleButtons(
              children: [_tabsNames[0]],
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
                minWidth: 80.0,
              ),
            ),
            ToggleButtons(
              children: [_tabsNames[1]],
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
                minWidth: 80.0,
              ),
            ),
          ],
        ),
        // Container(
        //   margin: const EdgeInsets.all(20),
        //   child: MainHeading(text: _selectedTab1[0] ? "My posts" : "My bids"),
        // ),
        //  Container(
        //   margin: const EdgeInsets.all(20),
        //   child: MainHeading(text: _selectedTab1[0] ? "15" : "200"),
        // ),
        ProfileCars(
            carsToShow: carsToShow,
            selectedTab: "any",
            height: height,
            width: width)
      ]),
    );
  }
}
