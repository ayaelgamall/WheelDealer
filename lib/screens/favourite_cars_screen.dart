import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/car.dart';

List<dynamic> favouritesList = [];
String userId = "IQ8O7SsY85NmhVQwghef7RF966z1"; //TODO change userID

class FavouriteCarsScreen extends StatefulWidget {
  const FavouriteCarsScreen({super.key});

  static const routeName = '/favourites';
  @override
  State<FavouriteCarsScreen> createState() => _FavouriteCarsScreenState();
}

class _FavouriteCarsScreenState extends State<FavouriteCarsScreen> {
  int index = 0;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        favouritesList = map['favs'] as List<dynamic>;
      });
    });
    super.initState();
  }

  void addToFavourites(String c) async {
    setState(() {
      favouritesList.add(c);
    });
    UsersService().addToFavs(userId, c);
  }

  Future<void> removeFromFavourites(String i) async {
    setState(() {
      favouritesList.remove(i);
    });

    UsersService().removeFromFavs(userId, i);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseFirestore.instance.collection('users');
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
        appBar: AppBar(
          title: const Text(
            "Favourites",
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: favouritesList.length,
              itemBuilder: (BuildContext context, int index) {
                {
                  if (favouritesList.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return SizedBox(
                        height: 700,
                        child: Container(
                          child: ListView(
                            children: (favouritesList).map((carId) {
                              return Container(
                                  height: 228,
                                  width: 430,
                                  alignment: Alignment.topCenter,
                                  child: Dismissible(
                                      background: Container(
                                          height: 160,
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          alignment: Alignment.centerRight,
                                          color:
                                              Color.fromARGB(255, 135, 17, 8),
                                          margin: EdgeInsets.only(
                                              top: 9, bottom: 20),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          )),
                                      key: Key(carId),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (dir) {
                                        removeFromFavourites(carId);
                                      },
                                      child: Stack(children: [
                                        CarCard(
                                            width: 400,
                                            height: 200,
                                            rightMargin: 0,
                                            carId: carId),
                                        Positioned(
                                          top: 20,
                                          right: 20,
                                          child: InkWell(
                                              child: favouritesList
                                                      .contains(carId)
                                                  ? (Icon(Icons.favorite))
                                                  : Icon(Icons.favorite_border),
                                              onTap: () {
                                                favouritesList.contains(carId)
                                                    ? removeFromFavourites(
                                                        carId)
                                                    : addToFavourites(carId);
                                              }),
                                        )
                                      ])));
                            }).toList(),
                          ),
                        ));
                  }
                }
              }),
        ));
  }
}
