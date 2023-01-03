import 'package:bar2_banzeen/models/sort.dart';
import 'package:flutter/material.dart';

class SortCard extends StatelessWidget {
  double width;
  double height;
  Map<String, Object> appliedSort;
  SortCard(
      {super.key,
      required this.height,
      required this.width,
      required this.appliedSort});

  String _sort = Sort.mostRecent.name;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text("Sort"),
        onPressed: () {
          showModalBottomSheet(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return
                      // AlertDialog(
                      // content: SizedBox(
                      //     height: height / 2.7,
                      //     child: Form(
                      //       key: _formKey,
                      // child:
                      SizedBox(
                    height: height / 2.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Sort by",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        ListTile(
                          title: const Text("Most recent"),
                          trailing: Radio<String>(
                            value: Sort.mostRecent.name,
                            groupValue: _sort,
                            onChanged: (value) {
                              setState(
                                () {
                                  _sort = value ?? _sort;
                                },
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Price: low to high"),
                          trailing: Radio<String>(
                            fillColor: MaterialStateProperty.all(Colors.white),
                            value: Sort.lowestPrice.name,
                            groupValue: _sort,
                            onChanged: (value) {
                              setState(
                                () {
                                  _sort = value ?? _sort;
                                },
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Price: high to low"),
                          trailing: Radio<String>(
                            fillColor: MaterialStateProperty.all(Colors.white),
                            value: Sort.highestPrice.name,
                            groupValue: _sort,
                            onChanged: (value) {
                              setState(
                                () {
                                  _sort = value ?? _sort;
                                },
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Closet deadline"),
                          trailing: Radio<String>(
                            fillColor: MaterialStateProperty.all(Colors.white),
                            value: Sort.deadline.name,
                            groupValue: _sort,
                            onChanged: (value) {
                              setState(
                                () {
                                  _sort = value ?? _sort;
                                },
                              );
                            },
                          ),
                        ),
                        // ElevatedButton(
                        //     child: const Text("Apply"), onPressed: () {})
                      ],
                      //   ),
                      // ))
                    ),
                  );
                });
              });
        });
  }
}
