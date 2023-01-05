// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/car.dart';
import '../services/authentication_service.dart';

class BidsScreen extends StatefulWidget {
  final Function showBidsScreen;
  String userId;
  Car car;
  BidsScreen(
      {required this.showBidsScreen, required this.userId, required this.car});

  @override
  State<BidsScreen> createState() => _BidsScreenState();
}

class _BidsScreenState extends State<BidsScreen> {
  final TextEditingController _textController = TextEditingController();
  final String? submitError = null;

  SnackBar failureSnackBar(String? msg) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              msg ?? "Error! Sorry about that.",
              maxLines: 2,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade400,
    );
  }

  SnackBar successSnackBar() {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: const Text(
              "Your bid has been placed successfully!",
              maxLines: 2,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade400,
    );
  }

  void submitBid(int topBid) async {
    String? err;
    if (_textController.text.isEmpty) {
      err = "Please place your bid!";
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar(err));
    } else {
      int bidValue = int.parse(_textController.text);

      if (bidValue <= topBid) {
        err = "You must bid higher to be the Top Bidder!";
        ScaffoldMessenger.of(context).showSnackBar(failureSnackBar(err));
      } else {
        err = await CarsService()
            .submitBid(widget.userId, widget.car.id!, bidValue);
        _textController.clear();
        if (err == null) {
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(failureSnackBar(err));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.7),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      widget.showBidsScreen(false);
                    },
                    icon: Icon(Icons.close_rounded)),
              ),
            ),
            onTap: () {
              widget.showBidsScreen(false);
            }),
        //TODO the bids screen itself
        Center(
          child: SingleChildScrollView(
            child: Center(
              //FutureBuilder to get the car document.
              child: FutureBuilder(
                  future: CarsService().fetchCar(widget.car.id!),
                  builder: (context, car) {
                    if (!car.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      // width: 310,
                      // height: 500,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              // width: 310,
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    onError: ((exception, stackTrace) {}),
                                    image: NetworkImage(car.data!.photos![0]
                                        // 'https://googleflutter.com/sample_image.jpg'
                                        ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: CarsService()
                                    .fetchCarTopBids(widget.car.id!),
                                builder: (context, bids) {
                                  print(bids.data!.docs.length);
                                  if (!bids.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Container(
                                    // width: 310,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    height: 330,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF555555),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0.0),
                                            child: Text(
                                              "Top Bidders",
                                              style: TextStyle(
                                                  color: Color(0xFF15BBAF),
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxHeight: 200),
                                            child: bids.data!.size > 0
                                                ? ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (itemContext, index) {
                                                      return FutureBuilder(
                                                          future: UsersService()
                                                              .fetchUser(bids
                                                                      .data!
                                                                      .docs[index]
                                                                      .data()[
                                                                  'user']),
                                                          builder:
                                                              (context, user) {
                                                            if (user.data ==
                                                                    null ||
                                                                !user.hasData) {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }
                                                            return Card(
                                                              // decoration:
                                                              //     BoxDecoration(
                                                              //   border: Border(
                                                              //     bottom: BorderSide(
                                                              //         style: index ==
                                                              //                 bids.data!.docs.length -
                                                              //                     1
                                                              //             ? BorderStyle
                                                              //                 .none
                                                              //             : BorderStyle
                                                              //                 .solid,
                                                              //         width: 3.0,
                                                              //         color: Color(
                                                              //             0xFF555555)),
                                                              //   ),
                                                              // ),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                ),
                                                              ),
                                                              elevation: 10,
                                                              child: ListTile(
                                                                style:
                                                                    ListTileStyle
                                                                        .list,
                                                                leading:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(user.data!.profilePhotoLink == null || user.data!.profilePhotoLink == ""
                                                                            ? "https://firebasestorage.googleapis.com/v0/b/bar2-banzeen.appspot.com/o/images%2FuserIcon.png?alt=media&token=aa3858d9-1416-4c79-a987-a87d85dc1397"
                                                                            : user
                                                                                .data!.profilePhotoLink!),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  user.data!
                                                                      .displayName,
                                                                  style:
                                                                      TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                trailing: Text(
                                                                    "${bids.data!.docs[index]['value']} E£"
                                                                        .toString()),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    // itemCount: bids.data!.docs.length,
                                                    itemCount: min(
                                                        bids.data!.docs.length,
                                                        3),
                                                  )
                                                : Center(
                                                    child: Text(
                                                        "Be the first bidder!"),
                                                  ),
                                          ),
                                          SizedBox(
                                            height: 45,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Card(
                                                      // elevation: 10,
                                                      child: TextField(
                                                        // textAlign: TextAlign.center,
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _textController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  top: 6,
                                                                  left: 8),
                                                          hintStyle: TextStyle(
                                                              color: Color(
                                                                      0xFFF5F5F5)
                                                                  .withOpacity(
                                                                      0.5)),
                                                          hintText:
                                                              "Place Your Bid",
                                                          // border:
                                                          //     OutlineInputBorder(
                                                          //         borderSide:
                                                          //             BorderSide(
                                                          //           width:
                                                          //               1,
                                                          //           color:
                                                          //               Color(
                                                          //             0xFFF5F5F5,
                                                          //           ),
                                                          //         ),
                                                          //         borderRadius:
                                                          //             BorderRadius.all(Radius.circular(10))),
                                                          // focusedBorder: OutlineInputBorder(
                                                          //     borderSide: BorderSide(
                                                          //         width:
                                                          //             1,
                                                          //         color: Color(
                                                          //             0xFFF5F5F5)),
                                                          //     borderRadius:
                                                          //         BorderRadius.all(
                                                          //             Radius.circular(10))),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.5,
                                                                color: Color(
                                                                        0xFFF5F5F5)
                                                                    .withOpacity(
                                                                        0.5)),
                                                            // borderRadius: BorderRadius.all(
                                                            //   Radius.circular(10),
                                                            // ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                        ),
                                                        // elevation: MaterialStateProperty.all<double>(10.0),
                                                      ),
                                                      onPressed: () async {
                                                        int highestValue;
                                                        if (bids.data!.size ==
                                                            0) {
                                                          highestValue = widget
                                                              .car
                                                              .startingPrice;
                                                        } else {
                                                          highestValue = bids
                                                              .data!
                                                              .docs
                                                              .first['value'];
                                                        }
                                                        submitBid(highestValue);
                                                      },
                                                      child: Text(
                                                        "Bid",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                        // child: Column(
                        //   children: [
                        //     Container(
                        //       width: 310,
                        //       height: 180,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10),
                        //             topRight: Radius.circular(10)),
                        //         shape: BoxShape.rectangle,
                        //         image: DecorationImage(
                        //             onError: ((exception, stackTrace) {}),
                        //             image: NetworkImage(car.data!.photos![0]
                        //                 // 'https://googleflutter.com/sample_image.jpg'
                        //                 ),
                        //             fit: BoxFit.fill),
                        //       ),
                        //     ),
                        //     Column(
                        //       children: [
                        //         //StreamBuilder to listen to the top 3 bids on this car.
                        //         StreamBuilder<
                        //                 QuerySnapshot<Map<String, dynamic>>>(
                        //             stream: CarsService()
                        //                 .fetchCarTopBids(widget.car.id),
                        //             builder: (context, bids) {
                        //               if (!bids.hasData) {
                        //                 return Center(
                        //                     child: CircularProgressIndicator());
                        //               }
                        //               return Container(
                        //                 width: 310,
                        //                 height: 300,
                        //                 decoration: BoxDecoration(
                        //                   color: Color(0xFF555555),
                        //                   borderRadius: BorderRadius.only(
                        //                       bottomLeft: Radius.circular(10),
                        //                       bottomRight: Radius.circular(10)),
                        //                 ),
                        //                 child: Padding(
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: 15),
                        //                   child: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceEvenly,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             top: 0.0),
                        //                         child: Text(
                        //                           "Top Bidders",
                        //                           style: TextStyle(
                        //                               color: Color(0xFF15BBAF),
                        //                               fontSize: 21,
                        //                               fontWeight:
                        //                                   FontWeight.w500),
                        //                         ),
                        //                       ),
                        //                       Container(
                        //                         decoration: BoxDecoration(
                        //                           border: Border.all(
                        //                               color: Colors.white),
                        //                           borderRadius:
                        //                               BorderRadius.circular(10),
                        //                           shape: BoxShape.rectangle,
                        //                         ),
                        //                         child: ListView.builder(
                        //                           scrollDirection:
                        //                               Axis.vertical,
                        //                           shrinkWrap: true,
                        //                           itemBuilder:
                        //                               (itemContext, index) {
                        //                             return FutureBuilder(
                        //                                 future: UsersService()
                        //                                     .fetchUser(bids
                        //                                             .data!
                        //                                             .docs[index]
                        //                                             .data()[
                        //                                         'user']),
                        //                                 builder:
                        //                                     (context, user) {
                        //                                   if (!user.hasData) {
                        //                                     return Center(
                        //                                         child:
                        //                                             CircularProgressIndicator());
                        //                                   }
                        //                                   return Container(
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       border: Border(
                        //                                         bottom: BorderSide(
                        //                                             style: index ==
                        //                                                     bids.data!.docs.length -
                        //                                                         1
                        //                                                 ? BorderStyle
                        //                                                     .none
                        //                                                 : BorderStyle
                        //                                                     .solid,
                        //                                             width: 0.0,
                        //                                             color: Colors
                        //                                                 .white),
                        //                                       ),
                        //                                     ),
                        //                                     child: ListTile(
                        //                                       style:
                        //                                           ListTileStyle
                        //                                               .list,
                        //                                       leading:
                        //                                           Container(
                        //                                         width: 40,
                        //                                         height: 40,
                        //                                         decoration:
                        //                                             BoxDecoration(
                        //                                           shape: BoxShape
                        //                                               .circle,
                        //                                           image: DecorationImage(
                        //                                               image: NetworkImage(
                        //                                                   'https://googleflutter.com/sample_image.jpg'),
                        //                                               fit: BoxFit
                        //                                                   .fill),
                        //                                         ),
                        //                                       ),
                        //                                       title: Text(
                        //                                         user.data!
                        //                                             .displayName,
                        //                                         style:
                        //                                             TextStyle(
                        //                                           overflow:
                        //                                               TextOverflow
                        //                                                   .ellipsis,
                        //                                         ),
                        //                                       ),
                        //                                       trailing: Text(
                        //                                           "${bids.data!.docs[index]['value']} E£"
                        //                                               .toString()),
                        //                                     ),
                        //                                   );
                        //                                 });
                        //                           },
                        //                           // itemCount: bids.data!.docs.length,
                        //                           itemCount: 3,
                        //                         ),
                        //                       ),
                        //                       Padding(
                        //                         padding: const EdgeInsets.only(
                        //                             bottom: 0.0),
                        //                         child: Row(
                        //                           mainAxisAlignment:
                        //                               MainAxisAlignment
                        //                                   .spaceBetween,
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.center,
                        //                           children: [
                        //                             Flexible(
                        //                               flex: 3,
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .all(0.0),
                        //                                 child: SizedBox(
                        //                                   height: 35,
                        //                                   child: TextField(
                        //                                     textAlign: TextAlign
                        //                                         .center,
                        //                                     inputFormatters: <
                        //                                         TextInputFormatter>[
                        //                                       FilteringTextInputFormatter
                        //                                           .digitsOnly
                        //                                     ],
                        //                                     keyboardType:
                        //                                         TextInputType
                        //                                             .number,
                        //                                     controller:
                        //                                         _textController,
                        //                                     decoration:
                        //                                         InputDecoration(
                        //                                       contentPadding:
                        //                                           EdgeInsets
                        //                                               .only(
                        //                                                   top:
                        //                                                       6),
                        //                                       hintStyle: TextStyle(
                        //                                           color: Color(
                        //                                                   0xFFF5F5F5)
                        //                                               .withOpacity(
                        //                                                   0.5)),
                        //                                       hintText:
                        //                                           "Place Your Bid",
                        //                                       border: OutlineInputBorder(
                        //                                           borderSide: BorderSide(
                        //                                               width: 1,
                        //                                               color: Color(
                        //                                                   0xFFF5F5F5)),
                        //                                           borderRadius:
                        //                                               BorderRadius.all(
                        //                                                   Radius.circular(
                        //                                                       10))),
                        //                                       focusedBorder: OutlineInputBorder(
                        //                                           borderSide: BorderSide(
                        //                                               width: 1,
                        //                                               color: Color(
                        //                                                   0xFFF5F5F5)),
                        //                                           borderRadius:
                        //                                               BorderRadius.all(
                        //                                                   Radius.circular(
                        //                                                       10))),
                        //                                       enabledBorder: OutlineInputBorder(
                        //                                           borderSide: BorderSide(
                        //                                               width: 1,
                        //                                               color: Color(
                        //                                                   0xFFF5F5F5)),
                        //                                           borderRadius:
                        //                                               BorderRadius.all(
                        //                                                   Radius.circular(
                        //                                                       10))),
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             Flexible(
                        //                               flex: 1,
                        //                               child: SizedBox(
                        //                                 height: 35,
                        //                                 child: ElevatedButton(
                        //                                     style: ButtonStyle(
                        //                                         shape: MaterialStateProperty.all<
                        //                                                 RoundedRectangleBorder>(
                        //                                             RoundedRectangleBorder(
                        //                                       borderRadius:
                        //                                           BorderRadius
                        //                                               .circular(
                        //                                                   10.0),
                        //                                     ))),
                        //                                     onPressed:
                        //                                         () async {
                        //                                       submitBid(bids
                        //                                               .data!
                        //                                               .docs
                        //                                               .first[
                        //                                           'value']);
                        //                                     },
                        //                                     child: Text(
                        //                                       "Bid",
                        //                                       style: TextStyle(
                        //                                           fontSize: 16),
                        //                                     )),
                        //                               ),
                        //                             )
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             }),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ),
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }
}
