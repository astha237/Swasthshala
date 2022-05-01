import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

getFromCamera() async {
  // ignore: deprecated_member_use
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
  }
}

//File(String path) {
//}
