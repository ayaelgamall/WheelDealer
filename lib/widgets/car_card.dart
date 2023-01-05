import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/car.dart';

class CarCard extends StatelessWidget {
  double height;
  double width;
  double rightMargin;
  String location;
  String? carId;

  CarCard(
      {super.key,
      required this.width,
      required this.height,
      required this.rightMargin,
      required this.location,
      this.carId});

  @override
  Widget build(BuildContext context) {
    final car = FirebaseFirestore.instance.collection('cars').doc(carId);
    int? bid = 0;
    return FutureBuilder<DocumentSnapshot>(
        future: car.get(),
        builder: (context, doc) {
          if (!doc.hasData) {
            //TODOL: to be replaced by error check maybe?
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Map<String, dynamic> carData =
                doc.data!.data() as Map<String, dynamic>;
            final topBid = carData['bids_count'] > 0
                ? CarsService().carTopBid(carId)
                : null;
            bid = carData['starting_price'];
            return GestureDetector(
                onTap: () {
                  Car car = Car(
                      id: doc.data!.id,
                      bidsCount: carData['bids_count'],
                      brand: carData['brand'],
                      color: carData['color'],
                      deadline: carData['deadline']!.toDate(),
                      description: carData['description'],
                      engineCapacity: carData['engine_capacity'],
                      location: carData['location'],
                      model: carData['model'],
                      photos: carData['photos'] is Iterable
                          ? List.from(carData['photos'])
                          : null,
                      creationTime: carData['creation_time']!.toDate(),
                      sellerId: carData['seller_id'],
                      sold: carData['sold'],
                      startingPrice: carData['starting_price'],
                      transmission: carData['transmission'],
                      year: '${carData['year']}',
                      mileage: carData['mileage']);
                  GoRouter.of(context)
                      .go('/${location}/car', extra: {'car': car, 'bid': bid});
                },
                child: Card(
                    margin: EdgeInsets.only(
                        top: 10, right: rightMargin, bottom: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    elevation: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              child: Image(
                                image: NetworkImage(
                                    carData['photos'][0]), // TODO read from db
                                height: 0.73 * height,
                                width: width,
                                fit: BoxFit.cover,
                              )),
                          Container(
                            width: width,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${carData['brand']} ${carData['model']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.bolt,
                                      color: Color.fromARGB(255, 183, 150, 19),
                                      size: 16,
                                    ),
                                    Text(
                                      "Top bid",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: width,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CardTimer(
                                      deadline: carData['deadline']!.toDate()),
                                  topBid == null
                                      ? Text(
                                          '${NumberFormat('###,000').format(carData['starting_price'])} EGP',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 183, 150, 19),
                                          ),
                                        )
                                      : FutureBuilder<QuerySnapshot>(
                                          future: topBid.get(),
                                          builder: (context, qs) {
                                            bid = qs.data?.docs.first['value'];
                                            if (!qs.hasData ||
                                                qs.connectionState ==
                                                    ConnectionState.waiting)
                                              return SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator());
                                            else
                                              return Text(
                                                '${NumberFormat('###,000').format(qs.data?.docs.first['value'])} EGP',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 183, 150, 19),
                                                ),
                                              );
                                          })
                                ],
                              ))
                        ])));
          }
        });
  }
}
