import 'package:bar2_banzeen/models/car.dart';
import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/car.dart';

class CarsService {
  final CollectionReference _carsReference =
      FirebaseFirestore.instance.collection("cars");

  Future<void> addCar(Car car) async {
    DocumentReference carDocument = await _carsReference.add({
      "brand": car.brand,
      "model": car.model,
      "year": int.parse(car.year),
      "transmission": car.transmission,
      "engine_capacity": car.engineCapacity,
      "mileage": car.mileage,
      "color": car.color,
      "location": car.location,
      "starting_price": car.startingPrice,
      "description": car.description,
      "deadline": Timestamp.fromDate(car.deadline
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1))),
      "seller_id": car.sellerId,
      "sold": false,
      "creation_time": Timestamp.fromDate(DateTime.now()),
      "bids_count": 0
    });

    String carId = carDocument.id;
    List<String> uploadedPhotos = await Future.wait(car.localPhotos!.map(
        (localPhoto) async =>
            await StorageService().uploadCarPhoto(carId, localPhoto!)));
    await _carsReference.doc(carId).update({"photos": uploadedPhotos});
  }

  Future<Car> fetchCar(String carId) async {
    DocumentSnapshot<Map<String, dynamic>> carDoc = await _carsReference
        .doc(carId)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Car car = Car(
        bidsCount: carDoc.data()?['bids_count'],
        brand: carDoc.data()?['brand'],
        color: carDoc.data()?['color'],
        deadline: (carDoc.data()?['deadline'] as Timestamp).toDate(),
        engineCapacity: carDoc.data()?['engine_capacity'],
        location: carDoc.data()?['location'],
        model: carDoc.data()?['model'],
        sellerId: carDoc.data()?['seller_id'],
        sold: carDoc.data()?['sold'],
        startingPrice: carDoc.data()?['starting_price'],
        transmission: carDoc.data()?['transmission'],
        year: carDoc.data()?['year'].toString() ??
            "No Specified Year, check method fetchCar in car_service",
        photos: carDoc.data()?['photos'].cast<String>());
    return car;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchCarTopBids(String carId) {
    return _carsReference
        .doc(carId)
        .collection("bids")
        .orderBy("value", descending: true)
        .limit(3)
        .snapshots();
  }

  Future<String?> submitBid(
      String userId, String carId, String bidValue) async {
    QuerySnapshot<Map<String, dynamic>> bidsDocs = await _carsReference
        .doc(carId)
        .collection("bids")
        .where('user', isEqualTo: userId)
        .get();

    DocumentReference<Map<String, dynamic>>? bidDoc;
    if (bidsDocs.docs.isNotEmpty) {
      try {
        await _carsReference
            .doc(carId)
            .collection("bids")
            .doc(bidsDocs.docs[0].id)
            .update({"user": userId, "value": int.parse(bidValue)});
      } catch (e) {
        return "Placing the bid failed!";
      }
    } else {
      await _carsReference
          .doc(carId)
          .collection("bids")
          .add({"user": userId, "value": int.parse(bidValue)});
    }

    //   .then((response) {
    // if (response.docs.isNotEmpty) {
    //   _carsReference
    //       .doc(carId)
    //       .collection("bids")
    //       .doc(response.docs[0].id)
    //       .set({"user": userId, "value": int.parse(bidValue)});
    // } else {
    //   _carsReference
    //       .doc(carId)
    //       .collection("bids")
    //       .add({"user": userId, "value": int.parse(bidValue)});
    // }
    // });
  }
}
