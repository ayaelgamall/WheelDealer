import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrendyCars extends StatelessWidget {
  double height;
  double width;
  TrendyCars({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final trendyCars = FirebaseFirestore.instance
        .collection('cars')
        .orderBy("bids_count", descending: true)
        .limit(5);

    return Container(
      height: height,
      child: FutureBuilder<QuerySnapshot>(
          future: trendyCars.get(),
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
                      carId: doc.id,
                    );
                  }).toList());
            }
          }),
    );
  }
}
