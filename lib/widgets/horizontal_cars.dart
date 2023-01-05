import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/users_service.dart';

class HorizontalCars extends StatelessWidget {
  double height;
  double width;
  Query<Map<String, dynamic>> carsToShow;
  HorizontalCars(
      {super.key,
      required this.width,
      required this.height,
      required this.carsToShow});

  @override
  Widget build(BuildContext context) {
    final curretUser = AuthenticationService().getCurrentUser();
    String userId = curretUser!.uid;
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
              return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((doc) {
                    return Stack(children: [
                      CarCard(
                          width: width,
                          height: height,
                          rightMargin: 20,
                          carId: doc.id,
                          location: 'mainPage'),
                      Positioned(
                          top: 20,
                          right: 30,
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
                                  Map<String, dynamic> map = snapshot.data!
                                      .data() as Map<String, dynamic>;
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
                  }).toList());
            }
          }),
    );
  }
}
