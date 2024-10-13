import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:totalx_task/controller/add_user_provider.dart';
import 'package:totalx_task/controller/home_provider.dart';
import 'package:totalx_task/view/widget/save_dialoge.dart';

class AlertBoxWidget extends StatelessWidget {
  AlertBoxWidget({
    super.key,
  });

  final CollectionReference _items =
      FirebaseFirestore.instance.collection("Upload_Items");

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add a new user",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Stack(
              children: [
                Consumer<UserProvider>(
                  builder: (context, userprovider, _) {
                    return CircleAvatar(
                      radius: 35,
                      backgroundImage: userprovider.imageUrl.isEmpty
                          ? null
                          : FileImage(File(userprovider.imageUrl)),
                    );
                  },
                ),
                Positioned(
                  top: 42,
                  child: Transform.rotate(
                    angle: 3.14 / 1,
                    child: const ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.4,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Color.fromARGB(165, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 32,
                  left: 12,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (_) {
                          return SizedBox(
                            height: 200,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Pick Image From",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.photo,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 20,
                                                  backgroundColor:
                                                      Colors.black),
                                              onPressed: () async {
                                                // add imagepicker for gallery
                                                userprovider.uploadImage(
                                                    ImageSource.gallery);
                                              },
                                              child: Text(
                                                "Gallery",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // const Text(
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.camera,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 20,
                                                  backgroundColor:
                                                      Colors.black),
                                              // camera image
                                              onPressed: () async {
                                                userprovider.uploadImage(
                                                    ImageSource.camera);
                                              },
                                              child: Text(
                                                "Camera",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                      
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Name : ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: userprovider.nameController,
            decoration: InputDecoration(
              hintText: "Enter name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Age : ",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: userprovider.ageController,
            decoration: InputDecoration(
              hintText: "Enter Age",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 206, 206, 206)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromARGB(255, 101, 101, 101),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 49, 73, 255)),
                child: MaterialButton(
                  //  save button
                  onPressed: () async {
                    if (userprovider.imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please select and Upload Image"),
                      ));
                      return;
                    }
                    final String name = userprovider.nameController.text;
                    final int? age =
                        int.tryParse(userprovider.ageController.text);
                    if (age != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const savedialogue();
                        },
                      );

                      await Future.microtask(() async {
                        await _items.add({
                          "name": name,
                          "age": age,
                          "image": await userprovider.imagepick(),
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                      homeprovider.getdata();
                      homeprovider.fetchalldata();
                      userprovider.nameController.text = "";
                      userprovider.ageController.text = '';
                      userprovider.image = '';
                      userprovider.imageUrl = '';
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
