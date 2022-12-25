import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:bar2_banzeen/widgets/view_more_button.dart';
import 'package:flutter/material.dart';

class TrendyCars extends StatelessWidget {
  double height;
  double width;
  TrendyCars({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    int count = 4;
    return Container(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, idx) {
          return CarCard(width: width, height: height, rightMargin: 20);
        },
        itemCount: count,
      ),
    );
  }
}
