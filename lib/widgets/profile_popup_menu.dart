import 'package:bar2_banzeen/services/cars_service.dart';
import 'package:bar2_banzeen/services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePopUpMenu extends StatelessWidget {
  String carID;
  ProfilePopUpMenu({super.key, required this.carID});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        // PopupMenuItem 1
        PopupMenuItem(
          value: 1,
          // row with 2 children
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Icon(Icons.edit),
              const SizedBox(
                width: 10,
              ),
              const Text("Edit post")
            ],
          ),
        ),
        // PopupMenuItem 2
        PopupMenuItem(
          value: 2,
          // row with two children
          child: Row(
            children: const [
              Icon(Icons.done),
              SizedBox(
                width: 10,
              ),
              Text("Mark as sold")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          // row with two children
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(
                width: 10,
              ),
              Text("Delete")
            ],
          ),
        ),
      ],
      padding: const EdgeInsets.all(0),
      offset: const Offset(0, 0),
      elevation: 0,
      onSelected: (value) {
        if (value == 1) {
        } else if (value == 2) {
          CarsService()
              .setCarSold(carID)
              .then((value) => ScaffoldMessenger.of(context)
                  .showSnackBar(createSnackBar("Marked as sold!", true)))
              .catchError((err) => ScaffoldMessenger.of(context)
                  .showSnackBar(createSnackBar("Action failed!", false)));
        } else {
          showAlertDialog(context, carID);
        }
      },
    );
  }

  showAlertDialog(BuildContext context, String carID) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
        child: const Text("Delete"),
        onPressed: () async {
          bool success = true;
          await CarsService()
              .deleteCar(carID)
              .then((value) {})
              .catchError((error) {
            success = false;
          });
          await UsersService()
              //TODO replace with user id
              .delteUserPost(carID, "fBDHfJIyBo908ecQdoaI")
              .then((value) {})
              .catchError((error) {
            success = false;
          });
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
                createSnackBar("Post deleted successfully!", true));
            Navigator.of(context).pop();
          } else
            ScaffoldMessenger.of(context)
                .showSnackBar(createSnackBar("Failed to delete post", false));
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete"),
      content: const Text("Are you sure you want to delete this post?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  SnackBar createSnackBar(String msg, bool success) {
    return SnackBar(
      content: Row(
        children: [
          success
              ? const Icon(
                  Icons.done_outlined,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
          const SizedBox(
            width: 10,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              msg,
              maxLines: 2,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      backgroundColor: success ? Colors.green : Colors.red.shade400,
    );
  }
}
