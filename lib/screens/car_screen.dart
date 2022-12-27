import 'package:flutter/material.dart';

class CarPage extends StatelessWidget {
  const CarPage({Key? key}) : super(key: key);
  static const routeName = '/car';


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body:

      Stack(
        children: [
          Positioned(
            top: 0,
            left:0,
            height:height*0.25,
            width: width,
            child: Image(
              image: AssetImage('assets/images/example.jpg'),
              height: 0.2 * height,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: height*0.22,
              left:0,
              height: 0.6*height,
              width: width,
              child: const Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                )),

                // child:
              ))
        ],
      ),
    );
  }
}
