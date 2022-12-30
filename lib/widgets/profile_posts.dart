import 'package:bar2_banzeen/widgets/profile_car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'car_card.dart';
import 'main_page_heading.dart';

class ProfilePosts extends StatelessWidget {
  double height;
  double width;
  List<String>? carsToShow;
  ProfilePosts(
      {super.key, this.carsToShow, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: carsToShow == null
          ? Text("No bids yet")
          : Column(
              children: carsToShow!.map((carID) {
              return ProfileCarCard(
                width: 0.89 * width,
                height: 0.4 * height,
                rightMargin: 0,
                carId: carID,
                cardType: 0,
              );
            }).toList()),
    );
  }
}
