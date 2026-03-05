import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

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
              Container(
                height: 150,
                width: 150,

                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),

                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(Icons.image)),
              ),
              SizedBox(width: 5),
              Container(
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
            ],
          ),
          SizedBox(height: 100),

          RoundedButton(title: "save", onPressed: () {}),
        ],
      ),
    );
  }
}
