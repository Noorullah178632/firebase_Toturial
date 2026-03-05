import 'package:firebase_project/viewModel/image_picker_view_model.dart';
import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageUploadView extends StatefulWidget {
  const ImageUploadView({super.key});

  @override
  State<ImageUploadView> createState() => _ImageUploadViewState();
}

class _ImageUploadViewState extends State<ImageUploadView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image")),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: .center,
            children: [
              Consumer<ImagePickerViewModel>(
                builder: (context, vm, child) {
                  return Container(
                    height: 150,
                    width: 150,

                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black),

                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: vm.selectedImage != null
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(vm.selectedImage!),
                                  fit: BoxFit
                                      .cover, // This "fixes" it to fill the circle
                                ),
                              ),
                            )
                          : Icon(Icons.image),
                    ),
                  );
                },
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  selectedImageForPhoto(context);
                },
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  padding: EdgeInsets.all(9),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        Icon(Icons.upload),
                        Text("upload ", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),

          Consumer<ImagePickerViewModel>(
            builder: (context, vm, child) {
              return RoundedButton(
                isLoading: vm.isLoading,
                title: "save",
                onPressed: () async {
                  await vm.uploadImageToCloudnary();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void selectedImageForPhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Center(
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () {
                    context.read<ImagePickerViewModel>().pickImage(
                      ImageSource.camera,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: ListTile(
                  leading: Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () {
                    context.read<ImagePickerViewModel>().pickImage(
                      ImageSource.gallery,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
