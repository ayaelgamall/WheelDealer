import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  double width;
  double height;
  String photoURL;
  ProfileAvatar(
      {super.key,
      required this.width,
      required this.height,
      required this.photoURL});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(photoURL),
            radius: 50,
          ),
          // Positioned(
          //     bottom: 0,
          //     right: -width / 10,
          //     child: RawMaterialButton(
          //       onPressed: () {},
          //       elevation: 2.0,
          //       child: Icon(
          //         size: 24,
          //         Icons.camera_alt_outlined,
          //       ),
          //       padding: EdgeInsets.all(15.0),
          //       shape: CircleBorder(),
          //     )),
        ],
      ),
    );
  }
}
