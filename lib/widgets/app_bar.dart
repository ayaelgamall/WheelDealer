import 'package:bar2_banzeen/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import '../screens/messages_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({ Key? key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{



  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.white,

      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
        ), IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            // showSearch(context: context, : MessagingScreen());
          },
        ),
      ],
    );
  }
}
