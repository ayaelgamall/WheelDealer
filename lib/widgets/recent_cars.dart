import 'package:bar2_banzeen/widgets/view_more_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Car.dart';
import 'car_card.dart';

class RecentCars extends StatelessWidget {
  double width;
  double height;
  RecentCars({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final recentCars = FirebaseFirestore.instance
        .collection('cars')
        .orderBy("creation_time", descending: true)
        .limit(5);

    return Container(
      height: height,
      child: FutureBuilder<QuerySnapshot>(
          future: recentCars.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //TODOL: to be replaced by error check maybe?
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((doc) {
                    return CarCard(
                        width: width,
                        height: height,
                        rightMargin: 20,
                        carId: doc.id);
                  }).toList());
            }
          }),
    );
  }
}
