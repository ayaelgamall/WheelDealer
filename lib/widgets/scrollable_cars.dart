import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/users_service.dart';

String userId = "IQ8O7SsY85NmhVQwghef7RF966z1"; //TODO change userID

class ScrollableCars extends StatelessWidget {
  double height;
  double width;
  Query<Map<String, dynamic>> carsToShow;
  Axis align;
  double rightMargin;
  ScrollableCars(
      {super.key,
      required this.width,
      required this.height,
      required this.carsToShow,this.align=Axis.horizontal,this.rightMargin=20});

  @override
  Widget build(BuildContext context) {
    final trendyCars = FirebaseFirestore.instance
        .collection('cars')
        .orderBy("bids_count", descending: true)
        .limit(5);

    return Container(
      height: height,
      child: FutureBuilder<QuerySnapshot>(
          future: carsToShow.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //TODOL: to be replaced by error check maybe?
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,

                  scrollDirection: align,
                  itemBuilder: (BuildContext context, int index) {
                    // if (index > snapshot.data!.docs.length - 1) {
                    //   snapshot = fetchMoreSnapshot();
                    // }
                    DocumentSnapshot doc = snapshot.data!.docs[index];

                  return Stack(children: [
                    CarCard(
                      width: width,
                      height: height,
                      rightMargin: rightMargin,
                      carId: doc.id,
                    ),
                    Positioned(
                        top: 20,
                        right: rightMargin + 10,
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return const InkWell(
                                    child: Icon(
                                  Icons.favorite_border,
                                ));
                              } else {
                                Map<String, dynamic> map = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                var favouritesList =
                                    map['favs'] as List<dynamic>;
                                return InkWell(
                                    child: favouritesList.contains(doc.id)
                                        ? (const Icon(Icons.favorite,
                                            color: Color.fromARGB(
                                                255, 146, 21, 12)))
                                        : const Icon(
                                            Icons.favorite_border,
                                          ),
                                    onTap: () {
                                      favouritesList.contains(doc.id)
                                          ? UsersService()
                                              .removeFromFavs(userId, doc.id)
                                          : UsersService()
                                              .addToFavs(userId, doc.id);
                                    });
                              }
                            }))
                  ]);
                },

              );
            }
          }),
    );
  }
}
