import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadCarPhoto(String carId, XFile img) async {
    final carImgRef = _storageRef.child("images/cars/$carId/${img.name}");
    await carImgRef.putFile(File(img.path));
    String downloadLink = await carImgRef.getDownloadURL();
    return downloadLink;
  }

  Future<void> clearCarPhotos(String carId) async {
    final carDirectory = _storageRef.child("images/cars/$carId/");
    carDirectory.delete();

    await FirebaseStorage.instance
        .ref("images/cars/$carId/")
        .listAll()
        .then((value) {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      });
    });
  }

  Future<List<File>> downloadCarPhotos(
      String carId, List<dynamic> linksD) async {
    List<String> strings = List<String>.from(linksD);
    List<File> files = [];
    int ctr = 0;
    final directory = await getTemporaryDirectory();
    for (String link in strings) {
      final response = await http.get(Uri.parse(link));

      //  print(directory.path);
      final file = File(join(directory.path, "$carId$ctr.jpg"));

      file.writeAsBytesSync(response.bodyBytes);
      files.add((file));
      ctr++;
      //  print(files);
    }
    return files;
  }

  Future<String> uploadUserPhoto(String userID, XFile img) async {
    final userImgRef = _storageRef.child("images/users/$userID/${img.name}");
    await userImgRef.putFile(File(img.path));
    String downloadLink = await userImgRef.getDownloadURL();
    return downloadLink;
  }
}
