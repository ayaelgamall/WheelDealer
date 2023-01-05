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

  Query queryCars1(String term) {
    print("term= " + term); //todo rem print
    return _carsReference.orderBy('brand').startAt([term]).endAt([term + '~']);

    // return _carsReference.orderBy('brand').startAt([term]).endAt([term + '\uf8ff']);
  }

  Query queryCars2(String term) {
    print("term= " + term); //todo rem print

    // return _carsReference.orderBy('brand').startAt([term]).endAt([term + '~']);

    return _carsReference
        .orderBy('brand')
        .startAt([term]).endAt([term + '\uf8ff']);
  }

  Future<List<String>> allCars() async {
    List allData = [];
    List<String> res = [];

    await _carsReference.get().then((querySnapshot) =>
        {allData = querySnapshot.docs.map((doc) => doc.data()).toList()});

    for (dynamic data in allData) {
      Map<String, dynamic> map = data as Map<String, dynamic>;
      res.add(map['brand'].toString());
      res.add(map['model'].toString());
    }
    print("all models and brands on db "+res.toString());
    return res;
  }
  Future<QuerySnapshot<Object?>>allCarsColl() async {

    QuerySnapshot<Object?>  res ;

   res= await _carsReference.get();
  return res;
}
}