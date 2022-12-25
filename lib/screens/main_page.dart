import 'package:bar2_banzeen/widgets/main_page_heading.dart';
import 'package:bar2_banzeen/widgets/recent_cars.dart';
import 'package:bar2_banzeen/widgets/trendy_cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/car_card.dart';
import '../widgets/view_more_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static const routeName = '/mainPage';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int count = 5;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "BeebBeeb",
            style: TextStyle(color: Color.fromARGB(255, 60, 64, 72)),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: ListView.builder(
            itemBuilder: (ctx, idx) {
              return idx == 0
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainHeading(text: "Trending"),
                            ViewMoreText(),
                          ],
                        ),
                        TrendyCars(
                          width: 0.73 * width,
                          height: 0.4 * height,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainHeading(text: "What's new"),
                            ViewMoreText()
                          ],
                        ),
                        RecentCars(width: 0.73 * width, height: 0.4 * height),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainHeading(text: "All cars"),
                            ViewMoreText()
                          ],
                        ),
                        // AllCars(width: 0.89 * width, height: 0.3 * height)
                      ],
                    )
                  : CarCard(
                      width: 0.89 * width,
                      height: 0.4 * height,
                      rightMargin: 0);
            },
            itemCount: count,
          ),
        ));
  }
}
