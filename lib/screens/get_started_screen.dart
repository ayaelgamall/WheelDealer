import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(children: [
      Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("lib/assets/images/backgrounds/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: const Text("")),
      Positioned(
        top: height / 7,
        left: width / 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DefaultTextStyle(
              child: Text('START'),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto'),
            ),
            DefaultTextStyle(
              child: Text('BIDDING ON'),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto'),
            ),
            DefaultTextStyle(
              child: Text('YOUR'),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto'),
            ),
            DefaultTextStyle(
              child: Text('FAVOURITE'),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto'),
            ),
            DefaultTextStyle(
              child: Text('CARS!'),
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto'),
            ),
          ],
        ),
      ),
      Positioned(
          width: 1.5 * width / 3,
          bottom: height / 8,
          left: width / 2 - width * 1.5 / 6,
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              child: const Text(
                "Get Started",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
              onPressed: () {},
            ),
          ))
    ]);
  }
}
