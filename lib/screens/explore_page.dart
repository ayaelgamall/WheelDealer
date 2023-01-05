import 'package:bar2_banzeen/widgets/app_bar.dart';
import 'package:bar2_banzeen/widgets/explore_Page_Content.dart';
import 'package:bar2_banzeen/widgets/search_bar.dart';
import 'package:bar2_banzeen/widgets/search_delegate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/scrollable_cars.dart';
import '../widgets/search_delegate.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);
  static const routeName = '/explore';


  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const historyLength = 5;

// The "raw" history that we don't access from the UI, prefilled with values
  List<String> _searchHistory = ['fuchsia',
    'flutter',
    'widgets',
    'resocoder',];
// The filtered & ordered history that's accessed from the UI
  late List<String> filteredSearchHistory;

// The currently searched-for term
  late String selectedTerm;
  final  controller = TextEditingController();


  bool searching =false;
  List<String> filterSearchTerms({
      required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  } //todo shared pref
  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      // This method will be implemented soon
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: '');
  }
  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }
  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }
  void initState() {
    super.initState();
    filteredSearchHistory = filterSearchTerms(filter: '');
    selectedTerm='';
  }
  // String searchValue = '';
  @override
  Widget build(BuildContext context) {
    // final cars = FirebaseFirestore.instance.collection('cars');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final cars = FirebaseFirestore.instance.collection('cars');
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: controller,
          // autocorrect: false,

          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(13),
            isDense: true,
            hintText: 'Search ',
            border: OutlineInputBorder(
              // borderSide: BorderSide(width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear_outlined),
              onPressed: () {
                setState(() {
                  // if(controller.text=='') {
                  //   controller.dispose();
                  // } else {
                    controller.clear();
                  // }
                });
              },
            ),
          ),
          onChanged: (query) {
            setState(() {
              searching=true;
              filteredSearchHistory = filterSearchTerms(filter: query);
            });
          },
          onTap: (){
            setState(() {
              searching=true;
            });
          },
          onSubmitted: (query){
            setState(() {
              if(query!='') {
                addSearchTerm(query);
              }
              selectedTerm = query;

              controller.clear();//as you leave leave it or add it
              searching=false;
            });
          },

        ),
        // backgroundColor: Colors.white,


      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: width*0.075, right: width*0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedTerm,style: Theme.of(context).textTheme.labelMedium,),

                    Row(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_drop_down),
                            label: Text('sort'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text('filter')),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: SizedBox( //todo update only when not searching
                    width: 0.85 * width,
                    child: ScrollableCars(
                      width: 0.85 * width,
                      height: 0.3 * height,
                      carsToShow: cars.orderBy("bids_count", descending: true),
                      //todo change
                      align: Axis.vertical,
                      rightMargin: 0,
                    ),
                  ),
                ),
                // CarCard(width: 0.8 * width, height: 0.3 * height, rightMargin: )
              ],
            ),
          ),
          if (searching) Card(
            // height: ,
            // color: Colors.brown,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredSearchHistory.length,
                itemBuilder: (BuildContext context, int index) {

                  return ListTile(
                    leading: Icon(Icons.history),
                    // dense: true,
                    title: Text(filteredSearchHistory[index]),
                    onTap: (){
                      setState(() {
                        selectedTerm = filteredSearchHistory[index];
                        addSearchTerm(filteredSearchHistory[index] );
                        searching=false;
                        controller.clear();


                      });
                    },
                  );
                }
            )
          )
        ],
      ),
    );
    // return Scaffold(
    //
    //
    //   appBar:
    //       SearchBar(),
    //   // EasySearchBar(
    //   //     title: Text('Example'),
    //   //     onSearch: (value) => setState(() => searchValue = value)
    //   // ),
    //   body: ExploreContent(),
    // );
  }
}
