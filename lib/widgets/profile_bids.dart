import 'package:bar2_banzeen/widgets/profile_car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'car_card.dart';
import 'main_page_heading.dart';

class ProfileBids extends StatelessWidget {
  double height;
  double width;
  Query<Map<String, dynamic>>? carsToShow;
  ProfileBids(
      {super.key, this.carsToShow, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: carsToShow == null
          ? Text("No posts yet")
          : FutureBuilder<QuerySnapshot>(
              future: carsToShow?.get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                      children: snapshot.data!.docs.map((doc) {
                    return ProfileCarCard(
                      bidValue: doc['value'],
                      width: 0.89 * width,
                      height: 0.4 * height,
                      rightMargin: 0,
                      carId: doc['car'],
                      cardType: 1,
                    );
                  }).toList());
                }
              }),
    );
  }
}
