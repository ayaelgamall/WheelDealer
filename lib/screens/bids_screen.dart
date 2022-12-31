// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BidsScreen extends StatefulWidget {
  final Function showBidsScreen;
  String userId = "";
  String carId = "";
  BidsScreen(this.showBidsScreen);

  @override
  State<BidsScreen> createState() => _BidsScreenState();
}

class _BidsScreenState extends State<BidsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.7),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: () {
                  widget.showBidsScreen(false);
                },
                icon: Icon(Icons.close_rounded)),
          ),
        ),
        //TODO the bids screen itself
        Center(
            child: Container(
          height: 500,
          // color: Colors.red,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: 342,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Color(0xFF555555),
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              Card(
                elevation: 8,
                child: Container(
                  width: 340,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://googleflutter.com/sample_image.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            ],
          ),
        ))
      ],
    ));
  }
}
