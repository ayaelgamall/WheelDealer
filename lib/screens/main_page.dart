import 'package:bar2_banzeen/widgets/main_page_heading.dart';
import 'package:bar2_banzeen/widgets/horizontal_cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/authentication_service.dart';
import '../services/users_service.dart';
import '../widgets/car_card.dart';
import '../widgets/view_more_button.dart';

List<dynamic> favouritesList = [];
String userId = "IQ8O7SsY85NmhVQwghef7RF966z1"; //TODO change userID

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static const routeName = '/mainPage';

  // @override
  void addToFavourites(String c) async {
    // setState(() {
    //   favouritesList.add(c);
    // });
    UsersService().addToFavs(userId, c);
  }

  Future<void> removeFromFavourites(String i) async {
    // setState(() {
    //   favouritesList.remove(i);
    // });

    UsersService().removeFromFavs(userId, i);
  }

  @override
  Widget build(BuildContext context) {
    final cars = FirebaseFirestore.instance.collection('cars');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int count = 5;
    return Scaffold(
        appBar: AppBar(title: Text("Hi"), actions: [
          IconButton(
            onPressed: () {
              AuthenticationService().signOut();
              context.go("/");
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              context.push("/mainPage/messages");
            },
            icon: Icon(Icons.message),
          )
        ]),
        // appBar: AppBar(
        //   title: const Text(
        //     "BeebBeeb",
        //     style: TextStyle(color: Color.fromARGB(255, 60, 64, 72)),
        //   ),
        // ),
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: FutureBuilder<QuerySnapshot>(
            future: cars.limit(5).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MainHeading(text: "Trending"),
                          ViewMoreText(),
                        ],
                      ),
                      HorizontalCars(
                        width: 0.73 * width,
                        height: 0.4 * height,
                        carsToShow: cars
                            .orderBy("bids_count", descending: true)
                            .limit(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MainHeading(text: "What's new"),
                          ViewMoreText()
                        ],
                      ),
                      HorizontalCars(
                        width: 0.73 * width,
                        height: 0.4 * height,
                        carsToShow: cars
                            .orderBy("creation_time", descending: true)
                            .limit(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MainHeading(text: "All cars"),
                          ViewMoreText()
                        ],
                      ),
                    ],
                  ),
                  ...snapshot.data!.docs.map((doc) {
                    return Stack(children: [
                      CarCard(
                          width: 0.89 * width,
                          height: 0.4 * height,
                          rightMargin: 0,
                          carId: doc.id),
                      Positioned(
                          top: 20,
                          right: 20,
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return InkWell(
                                      child: Icon(Icons.favorite_border));
                                } else {
                                  Map<String, dynamic> map = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  var favouritesList =
                                      map['favs'] as List<dynamic>;
                                  return InkWell(
                                      child: favouritesList.contains(doc.id)
                                          ? (const Icon(Icons.favorite))
                                          : const Icon(Icons.favorite_border),
                                      onTap: () {
                                        favouritesList.contains(doc.id)
                                            ? removeFromFavourites(doc.id)
                                            : addToFavourites(doc.id);
                                      });
                                }
                              }))
                    ]);
                  }).toList()
                ]);
              }
            },
          ),
        ));
  }
}
