import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  double height;
  double width;
  double rightMargin;
  String? brand;
  String? model;
  int? topBid; //TODO: to be added to the cars collection
  Timestamp? deadline; //TODO: Create card timer

  CarCard(
      {super.key,
      required this.width,
      required this.height,
      required this.rightMargin,
      this.brand,
      this.model,
      this.topBid,
      this.deadline});

  @override
  Widget build(BuildContext context) {
    final datDiff = deadline!.toDate().difference(DateTime.now());
    final remHours = datDiff.inHours;
    final remMin = datDiff.inMinutes % 60;
    final remSec = datDiff.inMinutes % 60;
    return InkWell(
      onTap: () {},
      child: Card(
          margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
          color: Color.fromARGB(255, 178, 178, 178),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          elevation: 4,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    child: Image(
                      image: AssetImage('assets/images/example.jpg'),
                      height: 0.73 * height,
                      width: width,
                      fit: BoxFit.cover,
                    )),
                Container(
                  width: width,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$brand $model",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 60, 64, 72),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            color: Color.fromARGB(255, 183, 150, 19),
                            size: 16,
                          ),
                          Text(
                            "Top bid",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 60, 64, 72),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    width: width,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          datDiff.isNegative
                              ? "Bid ended"
                              : "${remHours}H:${remMin}M:${remSec}S",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 64, 72),
                          ),
                        ),
                        Text(
                          "At \$275.750",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 150, 19),
                          ),
                        ),
                      ],
                    ))
              ])),
    );
  }
}
