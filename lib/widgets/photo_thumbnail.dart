import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoThumbnail extends StatelessWidget {
  PhotoThumbnail({super.key, required this.img, required this.removeFunction});
  XFile? img;
  void Function(XFile) removeFunction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(img!.path),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              removeFunction(img!);
            },
            child: const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.cancel),
            ),
          ),
        )
      ],
    );
  }
}
