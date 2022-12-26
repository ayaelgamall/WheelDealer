import 'package:bar2_banzeen/services/authentication_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SellCarScreen extends StatefulWidget {
  const SellCarScreen({super.key});

  static const routeName = '/sell-car';
  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Your Car"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: Form(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 100,
                      ),
                      Text("Upload Photo")
                    ],
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
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    hintText: "Brand", border: OutlineInputBorder()),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
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
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    hintText: "Model", border: OutlineInputBorder()),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Year"),
            ),
          ],
        ),
      ),
    );
  }
}
