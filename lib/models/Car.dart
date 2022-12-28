import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Car {
  String? id;
  String brand;
  String color;
  DateTime deadline;
  String description;
  int engineCapacity;
  int? mileage;
  String location;
  String model;
  List<String>? photos;
  List<XFile?>? localPhotos;
  int bidsCount;
  String sellerId;
  bool sold;
  int startingPrice;
  String transmission;
  String year;
  DateTime? creationTime;
  Car(
      {this.id,
      required this.bidsCount,
      required this.brand,
      required this.color,
      required this.deadline,
      this.description = "",
      required this.engineCapacity,
      required this.location,
      required this.model,
      this.photos,
      required this.sellerId,
      required this.sold,
      required this.startingPrice,
      required this.transmission,
      required this.year,
      this.mileage,
      this.localPhotos,
      this.creationTime});
  factory Car.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Car(
      id: data?['id'],
      bidsCount: data?['bids_count'],
      brand: data?['brand'],
      color: data?['color'],
      deadline: data?['deadline'],
      description: data?['deadline'],
      engineCapacity: data?['engine_capacity'],
      location: data?['location'],
      model: data?['model'],
      photos: data?['photos'] is Iterable ? List.from(data?['photos']) : null,
      creationTime: data?['creation_time'],
      sellerId: data?['seller_id'],
      sold: data?['sold'],
      startingPrice: data?['starting_price'],
      transmission: data?['transmission'],
      year: data?['year'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (bidsCount != null) "bids_count": bidsCount,
      if (brand != null) "brand": brand,
      if (color != null) "color": color,
      if (deadline != null) "deadline": deadline,
      if (description != null) "regions": description,
      if (engineCapacity != null) "engine_capacity": engineCapacity,
      if (location != null) "location": location,
      if (model != null) "model": model,
      if (photos != null) "photos": photos,
      if (creationTime != null) "creation_time": creationTime,
      if (sellerId != null) "seller_id": sellerId,
      if (sold != null) "sold": sold,
      if (startingPrice != null) "starting_price": startingPrice,
      if (transmission != null) "transmission": transmission,
      if (year != null) "year": year,
    };
  }
}
