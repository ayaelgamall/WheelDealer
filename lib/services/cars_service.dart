import 'package:bar2_banzeen/services/storage_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
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
    await UsersService().updateUserPostedCars(car.sellerId, carId);
    List<String> uploadedPhotos = await Future.wait(car.localPhotos!.map(
        (localPhoto) async =>
            await StorageService().uploadCarPhoto(carId, localPhoto!)));
    await _carsReference.doc(carId).update({"photos": uploadedPhotos});
  }

  Future<void> editCar(Car car, String carId) async {
    await _carsReference.doc(carId).update({
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
    });

    StorageService().clearCarPhotos(carId);

    List<String> uploadedPhotos = await Future.wait(car.localPhotos!.map(
        (localPhoto) async =>
            await StorageService().uploadCarPhoto(carId, localPhoto!)));

    await _carsReference.doc(carId).update({"photos": uploadedPhotos});
    print("done editing");
  }

  Future<void> deleteCar(String carID) async {
    _carsReference.doc(carID).delete();
  }

  Future<void> setCarSold(String? carID) async {
    await _carsReference.doc(carID).update({"sold": true});
  }

  Query carTopBid(String? carId) {
    return _carsReference
        .doc(carId)
        .collection('bids')
        .orderBy('value', descending: true)
        .limit(1);
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

  Future<String?> submitBid(String userId, String carId, int bidValue) async {
    try {
      QuerySnapshot<Map<String, dynamic>> carBidsDocs = await _carsReference
          .doc(carId)
          .collection("bids")
          .where('user', isEqualTo: userId)
          .get();
      QuerySnapshot<Map<String, dynamic>> userBidsDocs = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(userId)
          .collection("bids")
          .where('car', isEqualTo: carId)
          .get();

      DocumentReference<Map<String, dynamic>> carDocRef =
          await FirebaseFirestore.instance.collection("cars").doc(carId);

      DocumentSnapshot<Map<String, dynamic>> carDoc =
          await FirebaseFirestore.instance.collection("cars").doc(carId).get();

      final batch = FirebaseFirestore.instance.batch();
      if (carBidsDocs.docs.isNotEmpty && userBidsDocs.docs.isNotEmpty) {
        DocumentReference<Map<String, dynamic>> bidCarDocRef = _carsReference
            .doc(carId)
            .collection("bids")
            .doc(carBidsDocs.docs[0].id);
        DocumentReference<Map<String, dynamic>> bidUserDocRef =
            FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("bids")
                .doc(userBidsDocs.docs[0].id);

        batch.update(bidCarDocRef, {"user": userId, "value": bidValue});
        batch.update(bidUserDocRef, {"car": carId, "value": bidValue});
      } else {
        DocumentReference<Map<String, dynamic>> carBidsColl =
            _carsReference.doc(carId).collection("bids").doc();
        DocumentReference<Map<String, dynamic>> userBidsColl = FirebaseFirestore
            .instance
            .collection("users")
            .doc(userId)
            .collection("bids")
            .doc();
        batch.set(carBidsColl, {"user": userId, "value": bidValue});
        batch.set(userBidsColl, {"car": carId, "value": bidValue});
        batch.update(
            carDocRef, {"bids_count": carDoc.data()?['bids_count'] + 1});
      }

      await batch.commit();
    } catch (e) {
      return "Sorry! Placing the bid failed.";
    }
  }
}
