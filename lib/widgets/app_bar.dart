import 'package:bar2_banzeen/widgets/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/messages_screen.dart';
import '../services/authentication_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title='WheelDealer';
  bool isSearch;
  bool isMessage;
  CustomAppBar({ Key? key,this.title='WheelDealer',this.isSearch=true,this.isMessage=true}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{



  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: ,
      title: Text(widget.title),
      // backgroundColor: Colors.white,


      actions: [
        if(widget.isSearch)IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // showSearch(context: context, delegate: CustomSearchDelegate());
            // showSearch(context: context, delegate: CustomSearchDelegate());
            context.go('/mainPage/explore');
          },
        ),
        if(widget.isSearch)IconButton(
        onPressed: () {
          context.push("/mainPage/messages");
        },
        icon: const ImageIcon(
            AssetImage(
                'lib/assets/images/icons/messenger 2.png'),),
      )
      ],
    );
  }
}
