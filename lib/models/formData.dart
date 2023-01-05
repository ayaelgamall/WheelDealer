import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormData {
  TextEditingController brand;
  TextEditingController model;
  TextEditingController year;
  String transmission;
  TextEditingController engineCapacity;
  TextEditingController mileage;
  TextEditingController color;
  TextEditingController location;
  TextEditingController price;
  TextEditingController description;
  TextEditingController deadlineController;
  List<XFile?> photos;
  String? id;

  FormData({
    this.id,
    required this.brand,
    required this.color,
    required this.deadlineController,
    required this.description,
    required this.engineCapacity,
    required this.location,
    required this.model,
    required this.photos,
    required this.price,
    required this.transmission,
    required this.year,
    required this.mileage,
  });
}
