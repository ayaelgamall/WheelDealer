import 'package:bar2_banzeen/widgets/app_bar.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/widgets/drawer.dart';
import 'package:bar2_banzeen/widgets/main_page_heading.dart';
import 'package:bar2_banzeen/widgets/scrollable_cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/users_service.dart';
import '../widgets/car_card.dart';
import '../widgets/view_more_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const routeName = '/mainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final curretUser = AuthenticationService().getCurrentUser();
    String userId = curretUser!.uid;
    final cars = FirebaseFirestore.instance.collection('cars');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: AppDrawer(location: 'mainPage'),
        body: Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: RefreshIndicator(
            onRefresh: () {
              return Future(() {
                setState(() {});
              });
            },
            child: FutureBuilder<QuerySnapshot>(
              future: cars.where('sold', isNotEqualTo: true).limit(5).get(),
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
                            const ViewMoreText(),
                          ],
                        ),
                        ScrollableCars(
                          width: 0.73 * width,
                          height: 0.4 * height,
                          carsToShow: cars
                              .where('sold', isNotEqualTo: true)
                              .orderBy('sold')
                              .orderBy("bids_count", descending: true)
                              .limit(5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MainHeading(text: "What's new"),
                            const ViewMoreText()
                          ],
                        ),
                        ScrollableCars(
                          width: 0.73 * width,
                          height: 0.4 * height,
                          carsToShow: cars
                              // .where('sold', isNotEqualTo: true)
                              .orderBy("creation_time", descending: true)
                              .limit(5),
                        ),

                        //   ],
                        // ),
                        // ScrollableCars(width:  0.89 * width, height: 0.4 * height, carsToShow: cars
                        //     ,align: Axis.vertical,rightMargin: 0,)
                        //  ScrollableCars(
                        //         width: 0.73 * width,
                        //         height: 0.4 * height,
                        //         carsToShow: cars
                        //             .where('sold', isNotEqualTo: true)
                        //             .orderBy('sold')
                        //             .orderBy("creation_time", descending: true)
                        //             .limit(5),
                        //       ),


                        //   ],
                        // ),
                        // ScrollableCars(width:  0.89 * width, height: 0.4 * height, carsToShow: cars
                        //     ,align: Axis.vertical,rightMargin: 0,)
                        //  ScrollableCars(
                        //         width: 0.73 * width,
                        //         height: 0.4 * height,
                        //         carsToShow: cars
                        //             .where('sold', isNotEqualTo: true)
                        //             .orderBy('sold')
                        //             .orderBy("creation_time", descending: true)
                        //             .limit(5),
                        //       ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MainHeading(text: "All cars"),
                            const ViewMoreText()
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
                          carId: doc.id,
                          location: 'mainPage',
                        ),
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
                                            : const Icon(Icons.favorite_border),
                                        onTap: () {
                                          favouritesList.contains(doc.id)
                                              ? UsersService().removeFromFavs(
                                                  userId, doc.id)
                                              : UsersService()
                                                  .addToFavs(userId, doc.id);
                                        });
                                  }
                                }))
                      ]);
                    }).toList()
                  ]);
                }
              },
            ),
          ),
        ));
  }
}
