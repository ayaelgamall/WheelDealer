import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewMoreButton extends StatelessWidget {
  double width;
  double height;
  ViewMoreButton({super.key, required this.width, required this.height});
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        color: Color.fromARGB(255, 178, 178, 178),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 4,
        child: Stack(children: [
          Image(
            image: AssetImage("assets/images/blurred.png"),
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: Align(
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "See more",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 64, 72),
                ),
              ),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(0.45 * width, 0.125 * height)),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 183, 150, 19))),
            ),
          )),
        ]));
  }
}
