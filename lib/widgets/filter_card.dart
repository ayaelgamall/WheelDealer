import 'package:bar2_banzeen/services/brandAndModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterCard extends StatefulWidget {
  double width;
  double height;
  Function setNewFilters;
  FilterCard(
      {super.key,
      required this.height,
      required this.width,
      required this.setNewFilters});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _priceMin = TextEditingController();
  final TextEditingController _priceMax = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var currAppliedFilters;

  String _selectedBrand = "Audi";

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _brand.dispose();
    _model.dispose();
    _year.dispose();
    _location.dispose();
    _priceMin.dispose();
    _priceMax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text("Filter"),
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
                return StatefulBuilder(
                  builder: (context, setState2) => SizedBox(
                    height: widget.height / 2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Filters",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 0.8 * widget.width,
                            height: 0.06 * widget.height,
                            child: DropdownSearch<String>(
                              selectedItem: _selectedBrand,
                              // TODO Create Items List
                              items: BrandAndModel().getBrands(),
                              onChanged: (value) {
                                setState2(() {
                                  _brand.text = value ?? "";
                                  _selectedBrand = _brand.text;
                                });
                              },
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Brand",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  prefixIcon: const Icon(Icons.search),
                                  hintStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 0.8 * widget.width,
                            height: 0.06 * widget.height,
                            child: DropdownSearch<String>(
                              selectedItem: BrandAndModel()
                                  .getModels(_selectedBrand)
                                  .first,
                              // TODO Create Items List
                              items: BrandAndModel().getModels(_selectedBrand),
                              onChanged: (value) {
                                _model.text = value ?? "";
                              },
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Model",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  prefixIcon: const Icon(Icons.search),
                                  hintStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 0.8 * widget.width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 0.38 * widget.width,
                                  height: 0.06 * widget.height,
                                  child: TextFormField(
                                    controller: _year,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (year) => 1900 <=
                                                (int.parse(
                                                    year == null || year.isEmpty
                                                        ? "0"
                                                        : year)) &&
                                            (int.parse(
                                                    year == null || year.isEmpty
                                                        ? "0"
                                                        : year)) <=
                                                DateTime.now().year
                                        ? null
                                        : "Please enter a valid year",
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      prefixIcon: const Icon(
                                          Icons.calendar_month_outlined),
                                      hintText: "Year",
                                      hintStyle: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 0.04 * widget.width),
                                SizedBox(
                                  width: 0.38 * widget.width,
                                  height: 0.06 * widget.height,
                                  child: TextFormField(
                                    controller: _location,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        hintText: "Location",
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        prefixIcon: const Icon(
                                            Icons.location_on_outlined)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // SizedBox(
                          //   width: 0.8 * widget.width,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: [
                          //       SizedBox(
                          //         width: 0.38 * widget.width,
                          //         height: 0.06 * widget.height,
                          //         child: TextFormField(
                          //           controller: _priceMin,
                          //           keyboardType: TextInputType.number,
                          //           inputFormatters: <TextInputFormatter>[
                          //             FilteringTextInputFormatter.digitsOnly
                          //           ],
                          //           decoration: InputDecoration(
                          //             border: OutlineInputBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(15)),
                          //             hintText: "Min price",
                          //             hintStyle: const TextStyle(fontSize: 12),
                          //             suffixText: "LE",
                          //             suffixStyle: const TextStyle(fontSize: 12),
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(width: 0.04 * widget.width),
                          //       SizedBox(
                          //         width: 0.38 * widget.width,
                          //         height: 0.06 * widget.height,
                          //         child: TextFormField(
                          //           controller: _priceMax,
                          //           keyboardType: TextInputType.number,
                          //           inputFormatters: <TextInputFormatter>[
                          //             FilteringTextInputFormatter.digitsOnly
                          //           ],
                          //           decoration: InputDecoration(
                          //             border: OutlineInputBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(15)),
                          //             hintText: "Max price",
                          //             hintStyle: const TextStyle(fontSize: 12),
                          //             suffixStyle: const TextStyle(fontSize: 12),
                          //             suffixText: "LE",
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            child: const Text("Apply"),
                            onPressed: () {
                              Map<String, dynamic> newFilters = {};
                              newFilters = {
                                "brand": _brand.text,
                                "model": _model.text,
                                "year": int.parse(_year.text),
                                "location": _location.text,
                              };
                              widget.setNewFilters(newFilters);
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
