import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/formData.dart';
import '../models/transmission.dart';
import 'dart:io';

import 'package:bar2_banzeen/models/car.dart';
import 'package:bar2_banzeen/services/brandAndModel.dart';
import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:bar2_banzeen/widgets/photo_thumbnail.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'drawer.dart';

DateTime _deadline = DateTime.now();

final _formKey = GlobalKey<FormState>();

int _descriptionLength = 0;

String _photosError = "";
List<XFile?> photos = [];

bool _photosLoading = false;
bool _enableSubmit = false;
bool _addingCar = false;
ImagePicker picker = ImagePicker();

class SellCarForm extends StatefulWidget {
  String? carId;
  FormData car;

  SellCarForm({super.key, this.carId, required this.car});
  @override
  State<SellCarForm> createState() => _SellCarFormState();
}

class _SellCarFormState extends State<SellCarForm> {
  String? carId;
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    widget.car.brand.dispose();
    widget.car.model.dispose();
    widget.car.year.dispose();
    widget.car.engineCapacity.dispose();
    widget.car.mileage.dispose();
    widget.car.color.dispose();
    widget.car.location.dispose();
    widget.car.price.dispose();
    widget.car.description.dispose();
    widget.car.deadlineController.dispose();
    super.dispose();
  }

  void updateSubmitEnable() {
    setState(() {
      _enableSubmit = _formKey.currentState != null &&
          _formKey.currentState!.validate() &&
          widget.car.photos.isNotEmpty;
    });
  }

  Future getImages() async {
    try {
      setState(() {
        _photosLoading = true;
      });
      photos = await picker.pickMultiImage();

      setState(() {
        _photosLoading = false;
        widget.car.photos.addAll(photos.take(10 - photos.length));
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
      widget.car.photos.remove(img);
      photos.remove(img);
    });
  }

  SnackBar successSnackBar(bool add) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.done,
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
                : const Text(
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
      widget.car.photos.clear();
      widget.car.brand.clear();
      widget.car.model.clear();
      widget.car.year.clear();
      widget.car.engineCapacity.clear();
      widget.car.mileage.clear();
      widget.car.color.clear();
      widget.car.location.clear();
      widget.car.price.clear();
      widget.car.description.clear();
      widget.car.deadlineController.clear();
      _deadline = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final curretUser = AuthenticationService().getCurrentUser();

    String userId = curretUser!.uid;
    return Scaffold(
        drawer: AppDrawer(
          location: 'sellCar',
        ),
        appBar: AppBar(
          title: const Text("Sell Your Car"),
          actions: [
            IconButton(
              onPressed: () {
                context.go("/sellCar/messages");
                // context.push("/messages");
              },
              icon: Icon(Icons.message),
            )
          ],
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 30),
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
                              border: Border.all(
                                  color: Theme.of(context).hintColor),
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
                        if (_photosError.isNotEmpty ||
                            widget.car.photos.isEmpty)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: widget.car.photos.isEmpty
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.car.photos.isEmpty
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
                        if (widget.car.photos.isNotEmpty && !_photosLoading)
                          Column(
                            children: [
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: PhotoThumbnail(
                                        img: widget.car.photos[index],
                                        removeFunction: deleteImage),
                                  ),
                                  itemCount: widget.car.photos.length,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        DropdownSearch<String>(
                          // TODO Create Items List
                          items: BrandAndModel().getBrands(),

                          enabled: !_addingCar,
                          validator: (value) => value == null || value.isEmpty
                              ? "Brand must not be empty"
                              : null,
                          onChanged: (value) {
                            widget.car.brand.text = value ?? "";
                          },
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Brand",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          selectedItem: widget.car.brand.text,

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
                          items:
                              BrandAndModel().getModels(widget.car.brand.text),
                          selectedItem: BrandAndModel()
                              .getModels(widget.car.brand.text)
                              .first,
                          enabled: !_addingCar,
                          validator: (value) => value == null || value.isEmpty
                              ? "Model must not be empty"
                              : null,
                          onChanged: (value) {
                            widget.car.model.text = value ?? "";
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
                          controller: widget.car.year,
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
                                      groupValue: widget.car.transmission,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            widget.car.transmission = value ??
                                                widget.car.transmission;
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
                                      groupValue: widget.car.transmission,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            widget.car.transmission = value ??
                                                widget.car.transmission;
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
                          controller: widget.car.engineCapacity,
                          validator: (value) =>
                              ((value == null || value.isEmpty))
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
                          controller: widget.car.mileage,
                          validator: (value) => value!.isEmpty
                              ? "Mileage must not be empty"
                              : null,
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
                                AssetImage(
                                    'lib/assets/images/icons/mileage.png'),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: widget.car.color,
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
                          controller: widget.car.location,
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
                          controller: widget.car.price,
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
                          controller: widget.car.description,
                          maxLines: 5,
                          maxLength: 500,
                          onChanged: (value) {
                            setState(() {
                              _descriptionLength =
                                  widget.car.description.text.length;
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
                          controller: widget.car.deadlineController,
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
                            widget.car.deadlineController.text =
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
                            setState(() {
                              _addingCar = true;
                            });
                            Car car = Car(
                                id: "",
                                bidsCount: 0,
                                brand: widget.car.brand.text,
                                color: widget.car.color.text,
                                deadline: _deadline,
                                engineCapacity:
                                    int.parse(widget.car.engineCapacity.text),
                                location: widget.car.location.text,
                                model: widget.car.model.text,
                                localPhotos: widget.car.photos,
                                creationTime: DateTime.now(),
                                sellerId: userId,
                                sold: false,
                                startingPrice: int.parse(widget.car.price.text),
                                transmission: widget.car.transmission,
                                year: widget.car.year.text,
                                description: widget.car.description.text,
                                mileage: int.parse(widget.car.mileage.text));
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
        ));
  }
}
