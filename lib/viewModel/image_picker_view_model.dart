import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_project/utils/utils_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerViewModel extends ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  //set Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //instance of image picker
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
    notifyListeners();
  }

  //cloudnary instance
  final cloudnary = CloudinaryPublic("dlszadbhz", "firebase_image");
  //cloudnary url
  String? _cloudinaryUrl;
  String? get cloudinaryUrl => _cloudinaryUrl;
  //function for cloudnary
  Future<void> uploadImageToCloudnary() async {
    if (selectedImage == null) return;
    setLoading(true);
    try {
      CloudinaryResponse response = await cloudnary.uploadFile(
        CloudinaryFile.fromFile(
          selectedImage!.path,
          resourceType: CloudinaryResourceType.Image,
          folder: "My_firebase_images",
        ),
      );
      _cloudinaryUrl = response.secureUrl;

      Utils().toastMessage("successfully added to the cloudnary", value: true);
    } on CloudinaryException catch (e) {
      Utils().toastMessage(e.toString(), value: false);
    } catch (e) {
      Utils().toastMessage("Error occured:${e.toString()}", value: false);
    } finally {
      setLoading(false);
    }
  }
}
