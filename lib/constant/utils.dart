import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<List<File>> pickImages() async {
  final ImagePicker imagePicker = ImagePicker();

  List<File> images = [];
  List<XFile>? selectedImages = await imagePicker.pickMultiImage();
  if (selectedImages.isNotEmpty) {
    for (int i = 0; i < selectedImages.length; i++) {
      images.add(File(selectedImages[i].path));
    }
  }
  return images;
}
