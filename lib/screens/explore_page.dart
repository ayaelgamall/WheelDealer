import 'package:bar2_banzeen/widgets/app_bar.dart';
import 'package:bar2_banzeen/widgets/explore_Page_Content.dart';
import 'package:bar2_banzeen/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/scrollable_cars.dart';
import '../widgets/search_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);
  static const routeName = '/explore';

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  @override
  Widget build(BuildContext context) {
    // final cars = FirebaseFirestore.instance.collection('cars');

    return Scaffold(


      appBar:CustomAppBar(),
      body: ExploreContent(),
    );
  }
}
