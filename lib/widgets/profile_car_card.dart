import 'package:bar2_banzeen/widgets/profile_popup_menu.dart';
import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileCarCard extends StatelessWidget {
  double cardType;
  double height;
  double width;
  double rightMargin;
  String? carId;
  int? bidValue;

  ProfileCarCard(
      {super.key,
      required this.cardType,
      required this.width,
      required this.height,
      required this.rightMargin,
      this.bidValue,
      this.carId});

  @override
  Widget build(BuildContext context) {
    final car = FirebaseFirestore.instance.collection('cars').doc(carId);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: car.snapshots(),
        builder: (context, doc) {
          if (!doc.hasData || doc.connectionState == ConnectionState.waiting) {
            //TODOL: to be replaced by error check maybe?
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
                    onTap: () {},
                    child: carCard(carData, topBid, doc.data!.id));
          }
        });
  }

  Widget carCard(Map<String, dynamic> carData,
      Query<Map<String, dynamic>>? topBid, String id) {
    return Card(
        margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 4,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              child: Image(
                image: const AssetImage(
                    'assets/images/example.jpg'), // TODO read from db
                height: 0.73 * height,
                width: width,
                fit: BoxFit.cover,
              )),
          Container(
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
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
                cardType == 0 && !carData['sold']
                    ? ProfilePopUpMenu(
                        carID: id,
                      )
                    : const Text(""),
                //     Row(
                //       children: [
                //         Icon(
                //           Icons.bolt,
                //           color: Color.fromARGB(255, 183, 150, 19),
                //           size: 16,
                //         ),
                //         Text(
                //           "Top bid",
                //           style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
              ],
            ),
          ),
          Container(
              width: width,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardTimer(deadline: carData['deadline']!.toDate()),
                  topBid == null
                      ? Text(
                          "At ${bidValue ?? carData['starting_price']} EGP",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 183, 150, 19),
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
                                color: Color.fromARGB(255, 183, 150, 19),
                              ),
                            );
                          })
                ],
              ))
        ]));
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
            elevation: 0,
            margin: EdgeInsets.only(top: 10, right: rightMargin, bottom: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Text(""),
          ),
        ),
        const Positioned.fill(
            left: 120,
            top: 120,
            child: Text(
              "Sold",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ))
      ],
    );
  }
}
