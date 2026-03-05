import 'dart:io';

import 'package:firebase_project/utils/utils_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerViewModel extends ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  final ImagePicker picker = ImagePicker();

  //make a function for it
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? imagePath = await picker.pickImage(source: source);
      if (imagePath != null) {
        _selectedImage = File(imagePath.path);
      }
    } catch (e) {
      Utils().toastMessage("Error in image picking ", value: false);
    }
  }
}
