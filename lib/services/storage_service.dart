import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadCarPhoto(String carId, XFile img) async {
    final carImgRef = _storageRef.child("images/cars/$carId/${img.name}");
    await carImgRef.putFile(File(img.path));
    String downloadLink = await carImgRef.getDownloadURL();
    return downloadLink;
  }

  Future<List<XFile>> downloadCarPhotos(List<dynamic> links_d) async {
    List<String> links_s = List<String>.from(links_d);
    List<XFile> results = [];
    for (String link in links_s as List<String>) {
      NetworkImage file = NetworkImage(link);
      XFile result = XFile(file.url);
      results.add(result);
    }
    return results;
  }

  Future<String> uploadUserPhoto(String userID, XFile img) async {
    final userImgRef = _storageRef.child("images/users/$userID/${img.name}");
    await userImgRef.putFile(File(img.path));
    String downloadLink = await userImgRef.getDownloadURL();
    return downloadLink;
  }
}
