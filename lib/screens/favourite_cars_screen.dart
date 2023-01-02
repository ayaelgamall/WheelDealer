import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/car.dart';

List<dynamic> favouritesList = [];
String userId = "FpAj5S40vpYCcGsGFowxqyVXelm2"; //TODO change userID

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

  // Future<void> updateFavsList(val) async {
  //   setState(() {});
  // }

  void addToFavourites(Car c) {
    setState(() async {
      favouritesList.add(c.id!);
      // await updateFavsList(favouritesList);
    });
  }

  Future<void> removeFromFavourites(String i) async {
    setState(() {
      favouritesList.remove(i);
    });

    UsersService().editFavs(userId, i);
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
                        child: ListView(
                          children: (favouritesList).map((carId) {
                            return Container(
                                height: 230,
                                width: 430,
                                child: Dismissible(
                                    background: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        color: Colors.red,
                                        // ignore: prefer_const_constructors
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    key: Key(carId),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (dir) {
                                      removeFromFavourites(carId);
                                    },
                                    child: ListTile(
                                        title: CarCard(
                                            width: 400,
                                            height: 200,
                                            rightMargin: 0,
                                            carId: carId))));
                          }).toList(),
                        ));
                  }
                }
              }),
        ));
  }
}
