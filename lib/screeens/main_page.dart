import 'package:bar2_banzeen/widgets/trendy_cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static const routeName = '/mainPage';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("BeebBeeb"),
        ),
        body: TrendyCars(
          width: 0.73 * width,
          height: 0.3 * height,
        ));
  }
}
