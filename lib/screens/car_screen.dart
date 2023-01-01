import 'dart:async';
import 'dart:core';

import 'package:bar2_banzeen/widgets/main_page_heading.dart';
import 'package:bar2_banzeen/widgets/timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

import '../models/Car.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);
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
    Car car =Car(
        id: "",
        bidsCount: 0,
        brand: "Porsche",
        color: "Python Green",
        deadline: DateTime.utc(2023,1,12) ,
        engineCapacity:2981,
        location: "New Cairo",
        model:"911 Speedster",
        photos: ['assets/images/example.jpg','assets/images/w400_BMW-G29-LCI-Z4-Roadster-22.jpg'],
        creationTime: DateTime.now(),
        sellerId: '12',
        sold: false,
        startingPrice: 2300000,
        transmission: "Automatic",
        year: "2019",
        description: 'Hi, this is the description about the car. I don’t know  what to write, but this is the description with a lot and a lot of details',
        mileage: 80000);
    List userInfo =getUserFromId(car.sellerId);
    String userPhoto = userInfo[0] ?? defaultPhoto;
    String userName=userInfo[1];


    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    int getHighestPrice(){ //todo getPrice
      return car.startingPrice;
    }
    return Scaffold(
      appBar: AppBar(),
      body:

      Stack(
        children: [
          Positioned(
              top: 0,
              left:0,
              height:height*0.30,
              width: width,
              child:PageIndicatorContainer(
                align: IndicatorAlign.bottom,
                length: car.photos!.length,
                indicatorSpace: 20.0,
                padding: const EdgeInsets.only(bottom: 30),
                indicatorColor: Colors.white,
                indicatorSelectorColor: Theme.of(context).hoverColor,
                shape: IndicatorShape.circle(size: 12),
                child:
                PageView(
                  controller: _pageController,
                  children: List.generate(
                    car.photos!.length,
                        (index) => Image(
                      image: AssetImage(car.photos![index]),
                      fit: BoxFit.cover,),
                  ),
                ),



              )

          ),
          Positioned(
              top: height*0.28,
              left:0,
              height: 0.6*height,
              width: width,
              child:  Card(
                  margin: const EdgeInsets.all(0),

                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  )),

                  child:Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeading(text: "${car.brand} ${car.model}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(car.year),
                            Text('${NumberFormat('#,##,000').format(getHighestPrice())} \$',style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.red),),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(

                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(userPhoto),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(userName,style: TextStyle(color:Theme.of(context).hoverColor,fontWeight:FontWeight.bold)),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined,size: 17,),
                                        Text(car.location)
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text("Ending In",style: TextStyle(color:Theme.of(context).hoverColor,fontWeight:FontWeight.bold)),
                                CardTimer(deadline: car.deadline,)
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30,),
                        MainHeading(text: "Specification",color:Theme.of(context).hoverColor,),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:    [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    const ImageIcon(
                                        AssetImage('lib/assets/images/icons/mileage.png'),
                                        size: 40
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        const Text("Mileage"),
                                        Text('${NumberFormat('#,##,000').format(car.mileage)}KM'),                            ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  children: [
                                    const ImageIcon(
                                        AssetImage('lib/assets/images/icons/transmission.png'),
                                        size: 40
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        const Text("Transmission"),
                                        Text(car.transmission),                            ],
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
                                        AssetImage('lib/assets/images/icons/engine.png'),
                                        size: 40
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        const Text("Engine"),
                                        Text('${car.engineCapacity} CC'),

                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  children:    [
                                    const Icon(Icons.color_lens_outlined,size: 38,) ,
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

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
                        const SizedBox(height: 30,),
                        MainHeading(text: "Description",color:Theme.of(context).hoverColor,),
                        const SizedBox(height: 15,),
                        Text(car.description,softWrap: true,),
                        const SizedBox(height: 30,),
                        Center(
                          child:  ElevatedButton.icon(
                            icon: const Padding(
                              padding: EdgeInsets.only(left:.0),
                              child: Icon(Icons.add),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            onPressed: () {  },
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text('Place a bid',),
                            ),

                          ),
                        )




                      ],),
                  )
              ))
        ],
      ),
    );

  }

  List getUserFromId(String uid) {//todo from fireStore

    return [null , "Gego Badrawy"] ;
  }

}