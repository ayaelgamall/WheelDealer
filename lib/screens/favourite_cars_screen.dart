import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

List<dynamic> favouritesList = [];

class FavouriteCarsScreen extends StatelessWidget {
  FavouriteCarsScreen({super.key});

  static const routeName = '/favourites';
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final curretUser = AuthenticationService().getCurrentUser();
    String userId = curretUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      favouritesList = map['favs'] as List<dynamic>;
    });
    return Scaffold(
        drawer: AppDrawer(
          location: 'favourites',
        ),
      appBar: CustomAppBar(
        title:
        "Favourites",
        location:'favourites' ,
      ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const InkWell(child: Icon(Icons.favorite_border));
              } else {
                Map<String, dynamic> map =
                    snapshot.data!.data() as Map<String, dynamic>;
                var favouritesList = map['favs'] as List<dynamic>;
                return Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: ListView.builder(
                      itemCount: favouritesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        {
                          if (favouritesList.isEmpty) {
                            return CircularProgressIndicator();
                          } else {
                            return SizedBox(
                                height: 700,
                                child: ListView(
                                  children: (favouritesList).map((carId) {
                                    return Container(
                                        height: 268,
                                        width: 400,
                                        alignment: Alignment.topCenter,
                                        child: Dismissible(
                                            background: Container(
                                                height: 160,
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                alignment:
                                                    Alignment.centerRight,
                                                color: const Color.fromARGB(
                                                    255, 146, 21, 12),
                                                margin: const EdgeInsets.only(
                                                    top: 9, bottom: 20),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                )),
                                            key: Key(carId),
                                            direction:
                                                DismissDirection.endToStart,
                                            onDismissed: (dir) {
                                              UsersService().removeFromFavs(
                                                  userId, carId);
                                            },
                                            child: Stack(children: [
                                              CarCard(
                                                  width: 380,
                                                  height: 240,
                                                  rightMargin: 0,
                                                  carId: carId,
                                                  location: 'favourites'),
                                              Positioned(
                                                top: 20,
                                                right: 20,
                                                child: InkWell(
                                                    child: const Icon(
                                                        Icons.favorite,
                                                        color: Color.fromARGB(
                                                            255, 146, 21, 12)),
                                                    onTap: () {
                                                      UsersService()
                                                          .removeFromFavs(
                                                              userId, carId);
                                                    }),
                                              )
                                            ])));
                                  }).toList(),
                                ));
                          }
                        }
                      }),
                );
              }
            }));
  }
}
