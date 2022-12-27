import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadCarPhoto(String carId, XFile img) async {
    final carImgRef = _storageRef.child("images/cars/$carId/${img.name}");
    await carImgRef.putFile(File(img.path));
    String downloadLink = await carImgRef.getDownloadURL();
    return downloadLink;
  }
}
