import 'dart:io';

import 'package:bar2_banzeen/models/car.dart';
import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:bar2_banzeen/widgets/photo_thumbnail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transmission.dart';
import '../services/storage_service.dart';

class SellCarScreen extends StatefulWidget {
  String? carId;

  SellCarScreen({super.key, this.carId});
  static const routeName = '/sell-car';
  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  List<XFile?> _photos = [];
  TextEditingController _brand = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _year = TextEditingController();
  String _transmission = Transmission.automatic.name;
  TextEditingController _engineCapacity = TextEditingController();
  TextEditingController _mileage = TextEditingController();
  TextEditingController _color = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  DateTime _deadline = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  int _descriptionLength = 0;

  String _photosError = "";

  bool _photosLoading = false;
  bool _enableSubmit = false;
  bool _addingCar = false;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    Map<String, dynamic> map = {};
    if (widget.carId != null) {
      FirebaseFirestore.instance
          .collection('cars')
          .doc(widget.carId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        map = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _brand = TextEditingController(text: map['brand']);
          _color = TextEditingController(text: map['color']);
          _deadlineController = TextEditingController(
              text: DateFormat('yMMMd').format(map['deadline'].toDate()));
          _engineCapacity =
              TextEditingController(text: map['engine_capacity'].toString());
          _location = TextEditingController(text: map['location']);
          _model = TextEditingController(text: map['model'] as String);
          _price =
              TextEditingController(text: map['starting_price'].toString());
          _transmission = map['transmission'].toString();
          _year = TextEditingController(text: map['year'].toString());
          _description = TextEditingController(text: map['description']);
          _mileage = TextEditingController(text: map['mileage '].toString());
          _photos = getCarPhotos(widget.carId!, map['photos']);
          print(_photos);
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _brand.dispose();
    _model.dispose();
    _year.dispose();
    _engineCapacity.dispose();
    _mileage.dispose();
    _color.dispose();
    _location.dispose();
    _price.dispose();
    _description.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void updateSubmitEnable() {
    setState(() {
      _enableSubmit = _formKey.currentState != null &&
          _formKey.currentState!.validate() &&
          _photos.isNotEmpty;
    });
  }

  Future getImages() async {
    try {
      setState(() {
        _photosLoading = true;
      });
      List<XFile> photos = await picker.pickMultiImage();
     
      setState(() {
        _photosLoading = false;
        _photos.addAll(photos.take(10 - _photos.length));
        _photosError = "";
      });
      updateSubmitEnable();
    } catch (_) {
      setState(() {
        _photosError = "Error in Adding Photos!";
      });
    }
  }

  void deleteImage(XFile? img) {
    setState(() {
      _photos.remove(img);
    });
  }

  List<XFile?> getCarPhotos(String carId, List<dynamic> list) {
    List<XFile?> xfiles = [];
    StorageService().downloadCarPhotos(carId, list).then((files) async {
      print('finished str serv');
      for (File file in files) {
        xfiles.add(XFile(file.path));
      }
      print(xfiles);
    });

    return xfiles;
  }

  SnackBar successSnackBar(bool add) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: add
                ? const Text(
                    "Car Added Successfully",
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                : Text(
                    "Car Edited Successfully",
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
    );
  }

  void clearForm() {
    setState(() {
      _photos.clear();
      _brand.clear();
      _model.clear();
      _year.clear();
      _engineCapacity.clear();
      _mileage.clear();
      _color.clear();
      _location.clear();
      _price.clear();
      _description.clear();
      _deadlineController.clear();
      _deadline = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Your Car"),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          updateSubmitEnable();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: !_addingCar
                            ? () {
                                getImages();
                              }
                            : null,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Theme.of(context).hintColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 100,
                              ),
                              Text("Add Photos (Max 10)")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_photosError.isNotEmpty || _photos.isEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: _photos.isEmpty
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Text(
                                  _photos.isEmpty
                                      ? "You must add some photos"
                                      : _photosError,
                                  style: const TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      if (_photosLoading)
                        SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator()
                                  : const CupertinoActivityIndicator()),
                        ),
                      if (_photos.isNotEmpty && !_photosLoading)
                        Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: PhotoThumbnail(
                                      img: _photos[index],
                                      removeFunction: deleteImage),
                                ),
                                itemCount: _photos.length,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      DropdownSearch<String>(
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
                        enabled: !_addingCar,
                        validator: (value) => value == null || value.isEmpty
                            ? "Brand must not be empty"
                            : null,
                        onChanged: (value) {
                          _brand.text = value ?? "";
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Brand",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
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
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownSearch<String>(
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
                        // selectedItem: ,
                        enabled: !_addingCar,
                        validator: (value) => value == null || value.isEmpty
                            ? "Model must not be empty"
                            : null,
                        onChanged: (value) {
                          _model.text = value ?? "";
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              hintText: "Model",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search)),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _year,
                        keyboardType: TextInputType.number,
                        enabled: !_addingCar,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (year) => 1900 <=
                                    (int.parse(year == null || year.isEmpty
                                        ? "0"
                                        : year)) &&
                                (int.parse(year == null || year.isEmpty
                                        ? "0"
                                        : year)) <=
                                    DateTime.now().year
                            ? null
                            : "Please enter a valid year",
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                          hintText: "Manufacturing Year",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Transmission",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: Radio<String>(
                                    value: Transmission.automatic.name,
                                    groupValue: _transmission,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _transmission =
                                              value ?? _transmission;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Automatic",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: Radio<String>(
                                    value: Transmission.manual.name,
                                    groupValue: _transmission,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _transmission =
                                              value ?? _transmission;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Manual",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _engineCapacity,
                        validator: (value) => ((value == null || value.isEmpty))
                            ? "Engine Capacity must not be empty"
                            : null,
                        enabled: !_addingCar,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: "Engine Capacity",
                            suffixText: "CC",
                            prefixIcon: Transform.scale(
                              scale: 0.6,
                              child: const ImageIcon(AssetImage(
                                  'lib/assets/images/icons/engine.png')),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _mileage,
                        validator: (value) =>
                            value!.isEmpty ? "Mileage must not be empty" : null,
                        enabled: !_addingCar,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: "Mileage",
                          suffixText: "KM",
                          prefixIcon: Transform.scale(
                            scale: 0.6,
                            child: const ImageIcon(
                              AssetImage('lib/assets/images/icons/mileage.png'),
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _color,
                        validator: (value) =>
                            value!.isEmpty ? "Color must not be empty" : null,
                        enabled: !_addingCar,
                        decoration: const InputDecoration(
                            hintText: "Color",
                            prefixIcon: Icon(Icons.color_lens_outlined)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _location,
                        validator: (value) => value!.isEmpty
                            ? "Location must not be empty"
                            : null,
                        enabled: !_addingCar,
                        decoration: const InputDecoration(
                            hintText: "Location",
                            prefixIcon: Icon(Icons.location_on_outlined)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? "Starting price must not be empty"
                            : null,
                        enabled: !_addingCar,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            hintText: "Starting Price",
                            prefixIcon: Icon(Icons.attach_money_outlined),
                            suffixText: "LE"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _description,
                        maxLines: 5,
                        maxLength: 500,
                        onChanged: (value) {
                          setState(() {
                            _descriptionLength = _description.text.length;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Description",
                          counterText: "$_descriptionLength/500",
                          enabled: !_addingCar,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _deadlineController,
                        validator: (value) => value!.isEmpty
                            ? "Deadline must not be empty"
                            : null,
                        readOnly: true,
                        enabled: !_addingCar,
                        decoration: const InputDecoration(
                            hintText: "Deadline",
                            prefixIcon: Icon(Icons.date_range)),
                        onTap: () async {
                          _deadline = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 30))) ??
                              DateTime.now();
                          _deadlineController.text =
                              DateFormat('yMMMd').format(_deadline);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: _enableSubmit && !_addingCar
                      ? () async {
                          // print(_brand.text);
                          setState(() {
                            _addingCar = true;
                          });
                          Car car = Car(
                              id: "",
                              bidsCount: 0,
                              brand: _brand.text,
                              color: _color.text,
                              deadline: _deadline,
                              engineCapacity: int.parse(_engineCapacity.text),
                              location: _location.text,
                              model: _model.text,
                              localPhotos: _photos,
                              creationTime: DateTime.now(),
                              sellerId: ' user.uid',
                              sold: false,
                              startingPrice: int.parse(_price.text),
                              transmission: _transmission,
                              year: _year.text,
                              description: _description.text,
                              mileage: int.parse(_mileage.text));
                          if (widget.carId == null) {
                            await CarsService().addCar(car);
                            setState(() {
                              _addingCar = false;
                              clearForm();
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackBar(true));
                          } else {
                            await CarsService().editCar(car, widget.carId!);
                            setState(() {
                              _addingCar = false;
                              clearForm();
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(successSnackBar(false));
                          }
                        }
                      : null,
                  child: _addingCar
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(fontSize: 20),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
