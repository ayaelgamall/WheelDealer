import 'package:bar2_banzeen/widgets/profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/horizontal_cars.dart';
import '../widgets/main_page_heading.dart';
import '../widgets/view_more_button.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final cars = FirebaseFirestore.instance.collection('cars');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("beeb")),
      body: ListView(children: [
        Stack(children: [
          Container(
            height: 0.33 * height,
            color: Color.fromARGB(255, 99, 93, 93),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ProfileAvatar(
                    width: 0.45 * width,
                    height: 0.15 * height,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Gego Elbadrawy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 3,
                ),
                Text("@Gego",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          SizedBox(
            height: 0.4 * height,
          ),
          Positioned.fill(
              top: (0.33 - 0.04) * height,
              right: 20,
              left: 20,
              bottom: 15,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: const Color(0xff434242),
                ),
                width: 0.89 * width,
                height: 0.08 * height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("255"),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Posts")
                            ],
                          ),
                          Column(
                            children: [
                              Text("15"),
                              SizedBox(
                                height: 3,
                              ),
                              Text("bids")
                            ],
                          )
                        ],
                      )
                    ]),
              )),
        ]),
        Container(
            margin: EdgeInsets.all(20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [MainHeading(text: "My posts"), ViewMoreText()],
              ),
              HorizontalCars(
                width: 0.73 * width,
                height: 0.4 * height,
                carsToShow: cars.limit(5), //TODO: replace with user posts
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [MainHeading(text: "My bids"), ViewMoreText()],
              ),
              HorizontalCars(
                width: 0.73 * width,
                height: 0.4 * height,
                carsToShow: cars.limit(5), //TODO: replace with user bids
              ),
            ])),
      ]),
    );
  }
}
