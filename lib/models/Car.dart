import 'dart:ffi';

import 'package:flutter/material.dart';

class Car {
  String id;
  String brand;
  String color;
  DateTime deadline;
  String description;
  int engineCapacity;
  String location;
  String model;
  List<String> photos;
  int bidsCount;
  String sellerId;
  bool sold;
  Float startingPrice;
  String transmission;
  String year;
  DateTime postDate;
  Car({
    required this.id,
    required this.bidsCount,
    required this.brand,
    required this.color,
    required this.deadline,
    this.description = "",
    required this.engineCapacity,
    required this.location,
    required this.model,
    required this.photos,
    required this.postDate,
    required this.sellerId,
    required this.sold,
    required this.startingPrice,
    required this.transmission,
    required this.year,
  });
}
