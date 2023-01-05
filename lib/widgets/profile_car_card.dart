import 'package:bar2_banzeen/widgets/profile_popup_menu.dart';
import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/car.dart';

class ProfileCarCard extends StatelessWidget {
  double cardType;
  double height;
  double width;
  double rightMargin;
  String? carId;
  int? bidValue;
  BuildContext ctx;

  ProfileCarCard(
      {super.key,
      required this.cardType,
      required this.width,
      required this.height,
      required this.rightMargin,
      this.bidValue,
      this.carId,
      required this.ctx});

  @override
  Widget build(BuildContext context) {
    final car = FirebaseFirestore.instance.collection('cars').doc(carId);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: car.snapshots(),
        builder: (context, doc) {
          if (!doc.hasData || doc.connectionState == ConnectionState.waiting) {
            //TODO: to be replaced by error check maybe?
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (doc.data!.data() == null) return Container();

            Map<String, dynamic> carData =
                doc.data!.data() as Map<String, dynamic>;
            final topBid = (carData['bids_count'] > 0)
                ? car
                    .collection("bids")
                    .orderBy("value", descending: true)
                    .limit(1)
                : null;

            return carData['sold']
                ? SoldCar(carData, topBid, doc.data!.id)
                : InkWell(
                    onTap: () {
                        // Car car = Car(
                        //     id: doc.data!.id,
                        //     bidsCount: carData['bids_count'],
                        //     brand: carData['brand'],
                        //     color: carData['color'],
                        //     deadline: carData['deadline']!.toDate(),
                        //     description: carData['description'],
                        //     engineCapacity: carData['engine_capacity'],
                        //     location: carData['location'],
                        //     model: carData['model'],
                        //     photos: carData['photos'] is Iterable
                        //         ? List.from(carData['photos'])
                        //         : null,
                        //     creationTime: carData['creation_time']!.toDate(),
                        //     sellerId: carData['seller_id'],
                        //     sold: carData['sold'],
                        //     startingPrice: carData['starting_price'],
                        //     transmission: carData['transmission'],
                        //     year: '${carData['year']}',
                        //     mileage: carData['mileage']);
                        // GoRouter.of(context)
                        //     .go('/profile/car', extra: {'car': car, 'bid': bidValue});

                    }, // TODO redirect to car page has error
                    child: carCard(carData, topBid, doc.data!.id));
          }
        });
  }

  Widget carCard(Map<String, dynamic> carData,
      Query<Map<String, dynamic>>? topBid, String id) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
          margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          elevation: 4,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    child: Image(
                      image: NetworkImage(carData['photos'][0]),
                      height: 0.7 * height,
                      width: width,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "${carData['brand']} ${carData['model']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            cardType == 0 && !carData['sold']
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: SizedBox(
                                      height: 10,
                                      child: ProfilePopUpMenu(
                                        carID: id,
                                        ctx: ctx,
                                      ),
                                    ),
                                  )
                                : const Text(""),
                          ],
                        ),
                      ),
                      Container(
                          width: width,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CardTimer(
                                  deadline: carData['deadline']!.toDate()),
                              topBid == null
                                  ? Text(
                                      "At ${bidValue ?? carData['starting_price']} EGP",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 183, 150, 19),
                                      ),
                                    )
                                  : FutureBuilder<QuerySnapshot>(
                                      future: topBid.get(),
                                      builder: (context, qs) {
                                        return Text(
                                          "At ${qs.data?.docs.first['value']} EGP",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 183, 150, 19),
                                          ),
                                        );
                                      })
                            ],
                          )),
                    ],
                  ),
                )
              ])),
    );
  }

  Widget SoldCar(Map<String, dynamic> carData,
      Query<Map<String, dynamic>>? topBid, String id) {
    return Stack(
      children: [
        carCard(carData, topBid, id),
        Positioned(
          top: 0,
          left: 0,
          height: height,
          width: width,
          child: Card(
            color: Colors.white54, //TODO: change according to scene,
            elevation: 4,
            margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Text(""),
          ),
        ),
        Positioned.fill(
            left: width / 2 - 32,
            top: height / 2 - 16,
            child: Text(
              "Sold",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber), //todo change color
            ))
      ],
    );
  }
}
