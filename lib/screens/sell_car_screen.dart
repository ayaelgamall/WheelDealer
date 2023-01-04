import 'dart:io';
import 'package:bar2_banzeen/models/formData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../widgets/sellCarForm.dart';

class SellCarScreen extends StatelessWidget {
  String? carId;

  SellCarScreen({super.key, this.carId});
  static const routeName = '/sell-car';

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);
    if (carId != null) {

      return FutureBuilder<Map<String,dynamic>>(
          future: getCar(carId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('car has data');
              Map<String, dynamic> map =
                  snapshot.data!['doc'].data() as Map<String, dynamic>;
              print(snapshot.data!['photos'].toString()+"photos snapshot");
              return SellCarForm(
                  car: FormData(
                      brand: TextEditingController(text: map['brand']),
                      color: TextEditingController(text: map['color']),
                      deadlineController: TextEditingController(
                          text: DateFormat('yMMMd')
                              .format(map['deadline'].toDate())),
                      engineCapacity: TextEditingController(
                          text: map['engine_capacity'].toString()),
                      location: TextEditingController(text: map['location']),
                      model:
                          TextEditingController(text: map['model'] as String),
                      price: TextEditingController(
                          text: map['starting_price'].toString()),
                      transmission: map['transmission'].toString(),
                      year: TextEditingController(text: map['year'].toString()),
                      description:
                          TextEditingController(text: map['description']),
                      mileage: TextEditingController(
                          text: map['mileage'].toString()),
                      id: carId!,
                      photos: snapshot.data!['photos']), carId: carId,);
            } else {
              //no such car
              return Container();
            }
          });
    } else {
      // creating car
      return SellCarForm(
        car: FormData(
            year: TextEditingController(),
            brand: TextEditingController(),
            color: TextEditingController(),
            deadlineController: TextEditingController(),
            description: TextEditingController(),
            engineCapacity: TextEditingController(),
            location: TextEditingController(),
            mileage: TextEditingController(),
            model: TextEditingController(),
            photos: [],
            price: TextEditingController(),
            transmission: 'automatic'), carId: null,
      );
    }
  }

  Future<Map<String, dynamic>> getCar(String? carId) async {
    DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('cars').doc(carId!).get();
    Map<String, dynamic> map = ref.data() as Map<String, dynamic>;
    List<XFile?> photos = await getCarPhotos(carId, map['photos']);
    return {"doc":ref,"photos":photos};
  }

  Future<List<XFile?>> getCarPhotos(String? carId, List<dynamic> list) async {
    List<XFile?> xfiles = [];
    StorageService().downloadCarPhotos(carId!, list).then((files) async {
      print('finished str serv');
      // print(files);
      for (File file in files) {
        xfiles.add(XFile(file.path));
      }
      // print(xfiles);
    });

    return xfiles;
  }
}
