import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/scrollable_cars.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);
  static const routeName = '/explore';

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {


  @override
  Widget build(BuildContext context) {
    // final cars = FirebaseFirestore.instance.collection('cars');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String selected = 'Top searches';
    final cars = FirebaseFirestore.instance.collection('cars');
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                // Text(selected,style: Theme.of(context).textTheme.labelMedium,),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.arrow_drop_down),
                  label: Text('sort'),),
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: (){}, child: Text('filter'))
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 0.85 * width,

                child: ScrollableCars(
                  width: 0.85 * width,
                  height: 0.3 * height,
                  carsToShow: cars
                      .orderBy("bids_count", descending: true),//todo change
                  align: Axis.vertical,
                  rightMargin: 0,
                ),
              ),
            ),
            // CarCard(width: 0.8 * width, height: 0.3 * height, rightMargin: )

          ],
        ),
      ),
    );
  }
}
