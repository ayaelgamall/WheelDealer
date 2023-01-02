import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/users_service.dart';
List<dynamic> favouritesList = [];
String userId = "IQ8O7SsY85NmhVQwghef7RF966z1"; //TODO change userID

class HorizontalCars extends StatefulWidget {
  double height;
  double width;
  Query<Map<String, dynamic>> carsToShow;
  HorizontalCars(
      {super.key,
      required this.width,
      required this.height,
      required this.carsToShow});

  @override
  State<HorizontalCars> createState() => _HorizontalCarsState();
}

class _HorizontalCarsState extends State<HorizontalCars> {
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
    final trendyCars = FirebaseFirestore.instance
        .collection('cars')
        .orderBy("bids_count", descending: true)
        .limit(5);

    return Container(
      height: widget.height,
      child: FutureBuilder<QuerySnapshot>(
          future: widget.carsToShow.get(),
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
                        width: widget.width,
                        height: widget.height,
                        rightMargin: 20,
                        carId: doc.id,
                      ),
                      Positioned(
                        top: 20,
                        right: 40,
                        child: InkWell(
                            child: favouritesList.contains(doc.id)
                                ? (Icon(Icons.favorite))
                                : Icon(Icons.favorite_border),
                            onTap: () {
                              favouritesList.contains(doc.id)
                                  ? removeFromFavourites(doc.id)
                                  : addToFavourites(doc.id);
                            }),
                      )
                    ]);
                  }).toList());
            }
          }),
    );
  }
}
