import 'package:bar2_banzeen/screens/favourite_cars_screen.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:bar2_banzeen/widgets/main_page_heading.dart';
import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../services/cars_service.dart';

class CarPage extends StatefulWidget {
  Car car;
  int? topBid;
  CarPage({Key? key, required this.car, this.topBid}) : super(key: key);
  static const routeName = '/car';

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final String defaultPhoto =
      'https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397';

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    // final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // final Car car = arguments['car'];
    Car car = widget.car;
    // final topBid = car.bidsCount > 0 ? CarsService().carTopBid(car.id) : null;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    int? getHighestPrice() {
      //todo getPrice
      return this.widget.topBid;
    }

    return Scaffold(
      appBar: AppBar(),
      // floatingActionButton: Container(
      //   width: width,
      //   height: 0.1 * height,
      //   child: SizedBox(
      //     width: 80,
      //     height: 30,
      //     child: ElevatedButton.icon(
      //       icon: const Padding(
      //         padding: EdgeInsets.only(left: .0),
      //         child: Icon(Icons.add),
      //       ),
      //       style: ButtonStyle(
      //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //           RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(7),
      //           ),
      //         ),
      //       ),
      //       onPressed: () {},
      //       label: const Padding(
      //         padding: EdgeInsets.symmetric(vertical: 10),
      //         child: Text(
      //           'Place a bid',
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              height: height * 0.30,
              width: width,
              child: PageIndicatorContainer(
                align: IndicatorAlign.bottom,
                length: car.photos!.length,
                indicatorSpace: 20.0,
                padding: const EdgeInsets.only(bottom: 30),
                indicatorColor: Colors.white,
                indicatorSelectorColor: Theme.of(context).hoverColor,
                shape: IndicatorShape.circle(size: 12),
                child: PageView(
                  controller: _pageController,
                  children: List.generate(
                    car.photos!.length,
                    (index) => Image(
                      image: NetworkImage(car.photos![index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          Positioned(
              top: height * 0.28,
              left: 0,
              height: 0.6 * height,
              width: width,
              child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 30, right: 30, bottom: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MainHeading(
                                      text:
                                          "${car.brand} ${car.model}, ${car.year}"),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(car.year),
                                  //     // Text(
                                  //     //   '${NumberFormat('#,##,000').format(getHighestPrice())} EGP',
                                  //     //   style: const TextStyle(
                                  //     //       fontWeight: FontWeight.bold,
                                  //     //       fontSize: 18),
                                  //     // ),
                                  //   ],
                                  // ),
                                  // Text(car.year),
                                  // Row(
                                  //   children: const [
                                  //     Icon(
                                  //       Icons.bolt,
                                  //       color:
                                  //           Color.fromARGB(255, 183, 150, 19),
                                  //       size: 16,
                                  //     ),
                                  //     Text(
                                  //       "Top bid",
                                  //       style: TextStyle(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   width: 80,
                                  //   height: 30,
                                  //   child: ElevatedButton.icon(
                                  //     icon: const Padding(
                                  //       padding: EdgeInsets.only(left: .0),
                                  //       child: Icon(
                                  //         Icons.add,
                                  //         size: 10,
                                  //       ),
                                  //     ),
                                  //     style: ButtonStyle(
                                  //       shape: MaterialStateProperty.all<
                                  //           RoundedRectangleBorder>(
                                  //         RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(7),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     onPressed: () {},
                                  //     label: const Padding(
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 10, horizontal: 3),
                                  //       child: Text(
                                  //         'bid',
                                  //         style: TextStyle(fontSize: 10),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 5),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(car.year),
                              //     // Text(
                              //     //   '${NumberFormat('#,##,000').format(getHighestPrice())} EGP',
                              //     //   style: const TextStyle(
                              //     //       fontWeight: FontWeight.bold,
                              //     //       fontSize: 18),
                              //     // ),
                              //   ],
                              // ),
                              SizedBox(height: 15),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: const [
                              //     Icon(
                              //       Icons.bolt,
                              //       color: Color.fromARGB(255, 183, 150, 19),
                              //       size: 16,
                              //     ),
                              //     Text(
                              //       "Top bid",
                              //       style: TextStyle(
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${NumberFormat('#,##,000').format(getHighestPrice())} EGP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context).hoverColor,
                                    ),
                                  ),
                                  // Row(
                                  //   children: const [
                                  //     Icon(
                                  //       Icons.bolt,
                                  //       color:
                                  //           Color.fromARGB(255, 183, 150, 19),
                                  //       size: 16,
                                  //     ),
                                  //     Text(
                                  //       "Top bid",
                                  //       style: TextStyle(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    width: 75,
                                    height: 30,
                                    child: ElevatedButton.icon(
                                      icon: const Padding(
                                        padding: EdgeInsets.only(left: .0),
                                        child: Icon(
                                          Icons.add,
                                          size: 14,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      label: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 2),
                                        child: Text(
                                          'bid',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                              future: UsersService().getUser(car.sellerId),
                              builder: (context, doc) {
                                if (!doc.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          doc.data!["profile_photo"] != null
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      doc.data![
                                                          "profile_photo"]))
                                              : CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'lib/assets/images/icons/userIcon.png')),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(doc.data!["display_name"],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .hoverColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 17,
                                                  ),
                                                  Text(car.location)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Ending In",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontWeight: FontWeight.bold)),
                                          CardTimer(
                                            deadline: car.deadline,
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          MainHeading(
                            text: "Specification",
                            color: Theme.of(context).hoverColor,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const ImageIcon(
                                          AssetImage(
                                              'lib/assets/images/icons/mileage.png'),
                                          size: 40),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Mileage"),
                                          Text(
                                              '${NumberFormat('#,##,000').format(car.mileage)}KM'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      const ImageIcon(
                                          AssetImage(
                                              'lib/assets/images/icons/transmission.png'),
                                          size: 40),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Transmission"),
                                          Text(car.transmission),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const ImageIcon(
                                          AssetImage(
                                              'lib/assets/images/icons/engine.png'),
                                          size: 40),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Engine"),
                                          Text('${car.engineCapacity} CC'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.color_lens_outlined,
                                        size: 38,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Color"),
                                          Text(car.color),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MainHeading(
                            text: "Description",
                            color: Theme.of(context).hoverColor,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            car.description,
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  // List getUserFromId(String uid) async {
  //   //todo from fireStore
  //   DocumentSnapshot userData = await UsersService().getUser(uid);
  //   return [null, "Gego Badrawy"];
  // }
}
