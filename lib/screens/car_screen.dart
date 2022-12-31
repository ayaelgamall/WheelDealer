import 'package:flutter/material.dart';

import 'package:page_indicator/page_indicator.dart';

import '../models/Car.dart';

class CarPage extends StatelessWidget {
  const CarPage({Key? key}) : super(key: key);
  static const routeName = '/car';


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
        engineCapacity:15000,
        location: "New Cairo",
        model:"911",
        photos: ['assets/images/example.jpg','assets/images/w400_BMW-G29-LCI-Z4-Roadster-22.jpg'],
        creationTime: DateTime.now(),
        sellerId: '12',
        sold: false,
        startingPrice: 2300000,
        transmission: "Automatic",
        year: "2019",
        mileage: 80000);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body:

      Stack(
        children: [
          Positioned(
            top: 0,
            left:0,
            height:height*0.25,
            width: width,
            child:PageIndicatorContainer(
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
              align: IndicatorAlign.bottom,
              length: car.photos!.length,
              indicatorSpace: 20.0,
              padding: const EdgeInsets.only(bottom: 30),
              indicatorColor: Colors.grey,
              indicatorSelectorColor: Theme.of(context).hoverColor,
              shape: IndicatorShape.circle(size: 12),



            )

          ),
          Positioned(
              top: height*0.22,
              left:0,
              height: 0.6*height,
              width: width,
              child: const Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                )),

                // child:
              ))
        ],
      ),
    );
  }
}
