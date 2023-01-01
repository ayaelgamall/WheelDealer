import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/car.dart';

List<String> favouritesList = [];
var userId = "FpAj5S40vpYCcGsGFowxqyVXelm2"; //TODO change userID

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
    setState(() {
      // .get()
      //   .then((DocumentSnapshot documentSnapshot) {
      // Map<String, String> map =
      //     documentSnapshot.data() as Map<String, String>;
      // favouritesList = map['favs'] as List<String>;
      // });
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

  void removeFromFavourites(int i) {
    setState(() async {
      favouritesList.remove(favouritesList[i]);
      // await updateFavsList(favouritesList);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseFirestore.instance.collection('users');
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "BeebBeeb",
            style: TextStyle(color: Color.fromARGB(255, 60, 64, 72)),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: FutureBuilder<DocumentSnapshot>(
            future: user.doc(userId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SizedBox(
                    height: 700,
                    child: ListView(
                      children: (snapshot.data?.get('favs') as List<dynamic>)
                          .map((mapEntry) {
                        return Container(
                            height: 230,
                            width: 430,
                            child: ListTile(
                                title: CarCard(
                                    width: 400,
                                    height: 200,
                                    rightMargin: 0,
                                    carId: mapEntry)));
                      }).toList(),
                    ));

                // ListView(children:(snapshot.data() as Map<String, String>){

                //     return CarCard(
                //         width: 300,
                //         height: 200,
                //         rightMargin: 0,
                //         carId: f.id);
                //   }).toList()
                // ]);
              }
            },
          ),
        ));
  }
}
