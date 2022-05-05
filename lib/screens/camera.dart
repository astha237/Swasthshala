import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> getFromCamera() async {
  // ignore: deprecated_member_use
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.camera,
    maxWidth: 500,
    maxHeight: 500,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    return imageFile;
  }
  return null;
}

//File(String path) {
//}
