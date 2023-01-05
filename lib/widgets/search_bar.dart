import 'package:bar2_banzeen/widgets/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/messages_screen.dart';
import '../services/authentication_service.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({ Key? key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>{



  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(

        decoration: InputDecoration(
          // contentPadding: EdgeInsets.all(13),
          isDense: true,
          hintText: 'Search',
          border: OutlineInputBorder(
            // borderSide: BorderSide(width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
        ),
        onTap: (){
          print("done");
        },
      ),
      // backgroundColor: Colors.white,


    );
  }
}
