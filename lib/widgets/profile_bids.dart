import 'package:bar2_banzeen/widgets/profile_car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'car_card.dart';
import 'main_page_heading.dart';

class ProfileBids extends StatelessWidget {
  double height;
  double width;
  BuildContext ctx;
  CollectionReference? carsToShow;
  ProfileBids(
      {super.key,
      this.carsToShow,
      required this.height,
      required this.width,
      required this.ctx});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: carsToShow == null
          ? const Center(child: Text("No bids yet"))
          : StreamBuilder<QuerySnapshot>(
              stream: carsToShow?.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                      children: snapshot.data!.docs.map((doc) {
                    return ProfileCarCard(
                      bidValue: doc['value'],
                      width: 0.8 * width,
                      height: 0.5 * height,
                      rightMargin: 0,
                      carId: doc['car'],
                      cardType: 1,
                      ctx: ctx,
                    );
                  }).toList());
                }
              }),
    );
  }
}
