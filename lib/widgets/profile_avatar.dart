import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  double width;
  double height;
  ProfileAvatar({super.key, required this.width, required this.height});
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
            backgroundImage: AssetImage("assets/images/example.jpg"),
            radius: 50,
          ),
          Positioned(
              bottom: 0,
              right: -width / 10,
              child: RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: Color(0xff434242),
                child: Icon(
                  Icons.camera_alt_outlined,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              )),
        ],
      ),
    );
  }
}
