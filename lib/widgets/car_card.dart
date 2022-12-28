import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  double height;
  double width;
  double rightMargin;
  String? carId;

  CarCard(
      {super.key,
      required this.width,
      required this.height,
      required this.rightMargin,
      this.carId});

  @override
  Widget build(BuildContext context) {
    final car = FirebaseFirestore.instance.collection('cars').doc(carId);
    final topBid =
        car.collection("bids").orderBy("value", descending: true).limit(1);

    return InkWell(
        onTap: () {},
        child: Card(
          margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          elevation: 4,
          child: FutureBuilder<DocumentSnapshot>(
              future: car.get(),
              builder: (context, doc) {
                if (!doc.hasData) {
                  //TODOL: to be replaced by error check maybe?
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Map<String, dynamic> carData =
                      doc.data!.data() as Map<String, dynamic>;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/example.jpg'), // TODO read from db
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardTimer(
                                    deadline: carData['deadline']!.toDate()),
                                FutureBuilder<QuerySnapshot>(
                                    future: topBid.get(),
                                    builder: (context, qs) {
                                      return Text(
                                        "At ${qs.hasData ? qs.data!.docs.first['value'] : carData['starting_price']} EGP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 183, 150, 19),
                                        ),
                                      );
                                    })
                              ],
                            ))
                      ]);
                }
              }),
        ));
  }
}
