import 'package:bar2_banzeen/models/car.dart';
import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}