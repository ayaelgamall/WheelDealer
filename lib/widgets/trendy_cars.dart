import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:flutter/material.dart';

class TrendyCars extends StatelessWidget {
  double height;
  double width;
  TrendyCars({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      // margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, idx) {
          return CarCard(width: width, height: height);
        },
        itemCount: 4,
      ),
    );
  }
}
