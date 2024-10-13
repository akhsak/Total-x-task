import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String imageUrl = "";
  String image = "";
// image picker
  Future<void> uploadImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      imageUrl = image.path;
    }

    notifyListeners();
  }

// image to firebase
  Future<String> imagepick() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImage = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDireImage.child(fileName);

    try {
      await referenceImageToUpload.putFile(File(imageUrl));

      return await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      throw (e);
    }
  }
}
