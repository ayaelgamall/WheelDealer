// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BidsScreen extends StatefulWidget {
  final Function showBidsScreen;
  String userId = "";
  String carId = "IUTYrlFptF2xpgqNayci";
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
        InkWell(
            child: Container(
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
            onTap: () {
              widget.showBidsScreen(false);
            }),
        //TODO the bids screen itself
        Center(
            child: FutureBuilder(
                future: CarsService().fetchCar(widget.carId),
                builder: (context, car) {
                  if (!car.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container(
                    height: 500,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream:
                                  CarsService().fetchCarTopBids(widget.carId),
                              builder: (context, bids) {
                                if (!bids.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return ListView.builder(
                                  itemBuilder: (itemContext, index) {
                                    return FutureBuilder(
                                        //edit future
                                        future: CarsService()
                                            .fetchCar(widget.carId),
                                        builder: (context, bid) {
                                          return Container();
                                        });
                                  },
                                );
                                // return Container(
                                //     width: 342,
                                //     height: 400,
                                //     decoration: BoxDecoration(
                                //       color: Color(0xFF555555),
                                //       borderRadius: BorderRadius.circular(10),
                                //     ));
                              }),
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
                                  onError: ((exception, stackTrace) {}),
                                  image: NetworkImage(car.data!.photos![0]
                                      // 'https://googleflutter.com/sample_image.jpg'
                                      ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }))
      ],
    ));
  }
}
