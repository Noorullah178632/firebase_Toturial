import 'package:firebase_project/viewModel/real_database_view_model.dart';
import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  TextEditingController postController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add post")),
      body: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Form(
              key: formKey,
              child: TextFormField(
                controller: postController,
                maxLines: 4, // This makes the field exactly 4 lines tall
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(), // Optional: adds a nice border
                ),
                validator: (value) {
                  // 1. Check if the field is null or just empty spaces
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter some text to post";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.h),

            Consumer<RealDatabaseViewModel>(
              builder: (context, vm, child) {
                return RoundedButton(
                  isLoading: vm.isLoading,
                  title: "Add post",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final success = await vm.addData(
                        postController.text.trim(),
                      );
                      if (!context.mounted) return;
                      if (success) {
                        postController.clear();
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
