import 'package:bar2_banzeen/widgets/car_card.dart';
import 'package:flutter/material.dart';

import '../models/car.dart';

class FavouriteCarsScreen extends StatefulWidget {
  const FavouriteCarsScreen({super.key});

  // List<Car> favouritesList=[];

  static const routeName = '/favourites';
  @override
  State<FavouriteCarsScreen> createState() => _FavouriteCarsScreenState();
}

// var prefs;

class _FavouriteCarsScreenState extends State<FavouriteCarsScreen> {
  int index = 0;

  // Future<void> getFavsList() async {
  // prefs = await SharedPreferences.getInstance();
  // setState(() {
  //   widget.favouritesList = prefs.getStringList('favs') ?? [];
  // });
  // }

  // Future<void> updateFavsList(val) async {
  //   setState(() {
  // prefs.setStringList('favs', val);
  //   });
  // }

  // void addToFavourites(Car c) {
  //   setState(() async {
  //     c.fav = true;
  //     widget.favouritesList.add(r);
  //     await updateFavsList(widget.favouritesList);
  //   });
  // }

  // void removeFromFavourites(int i) {
  //   setState(() {
  //     widget.favouritesList[i].fav = false;
  //     widget.favouritesList.remove(widget.favouritesList[i]);
  //     updateFavsList(widget.favouritesList);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favourites"),
        ),
        body: Container(
            width: 500,
            height: 500,
            child: Column(children: [
              Expanded(
                  child: Container(
                      child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                      width: 420,
                      child: ListTile(
                          title: Container(
                              width: 420,
                              child: CarCard(
                                  height: 200,
                                  width: 400,
                                  rightMargin: 0,
                                  carId: "6NmLIv2FH8IInkaRta0Y"))));
                },
                itemCount: 1,
              )))
            ])));
  }
}
