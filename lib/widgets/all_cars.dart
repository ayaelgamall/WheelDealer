// import 'package:bar2_banzeen/widgets/view_more_button.dart';
// import 'package:flutter/material.dart';

// import 'car_card.dart';

// class AllCars extends StatelessWidget {
//   double height;
//   double width;
//   AllCars({super.key, required this.width, required this.height});

//   @override
//   Widget build(BuildContext context) {
//     int count = 4;
//     return Container(
//       height: height,
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemBuilder: (ctx, idx) {
//           return idx == count - 1
//               ? ViewMoreButton(width: width * 0.45, height: height * 0.125)
//               : CarCard(width: width, height: height);
//         },
//         itemCount: count,
//       ),
//     );
//   }
// }
