import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterCard extends StatefulWidget {
  double width;
  double height;
  Map<String, Object> appliedFilters;
  FilterCard(
      {super.key,
      required this.height,
      required this.width,
      required this.appliedFilters});

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

  void initState() {
    setState(() {
      currAppliedFilters = widget.appliedFilters;
    });
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
        child: const Text("Place a bid"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SizedBox(
                    height: widget.height / 2.2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text("Filters"),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 0.8 * widget.width,
                            height: 0.06 * widget.height,
                            child: DropdownSearch<String>(
                              // TODO Create Items List
                              items: const [
                                "Mercedes",
                                "Hyundai",
                                "Toyota",
                                "Renault",
                                "BMW",
                                "Audi",
                                "Fiat"
                              ],
                              onChanged: (value) {
                                _brand.text = value ?? "";
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
                            height: 15,
                          ),
                          SizedBox(
                            width: 0.8 * widget.width,
                            height: 0.06 * widget.height,
                            child: DropdownSearch<String>(
                              // TODO Create Items List
                              items: const [
                                "Mercedes",
                                "Hyundai",
                                "Toyota",
                                "Renault",
                                "BMW",
                                "Audi",
                                "Fiat"
                              ],
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
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.3 * widget.width,
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
                              SizedBox(
                                width: 0.3 * widget.width,
                                height: 0.06 * widget.height,
                                child: TextFormField(
                                  controller: _location,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      hintText: "Location",
                                      hintStyle: const TextStyle(fontSize: 12),
                                      prefixIcon: const Icon(
                                          Icons.location_on_outlined)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0.3 * widget.width,
                                height: 0.06 * widget.height,
                                child: TextFormField(
                                  controller: _priceMin,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    hintText: "Min price",
                                    hintStyle: const TextStyle(fontSize: 12),
                                    suffixText: "LE",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 0.3 * widget.width,
                                height: 0.06 * widget.height,
                                child: TextFormField(
                                  controller: _priceMax,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    hintText: "Max price",
                                    hintStyle: const TextStyle(fontSize: 12),
                                    suffixText: "LE",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            child: const Text("Apply"),
                            onPressed: () {
                              // if (_formKey.currentState.validate()) {
                              //   _formKey.currentState.save();
                              // }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
