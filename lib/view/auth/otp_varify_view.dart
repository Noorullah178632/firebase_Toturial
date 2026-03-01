import 'package:firebase_project/view/posts/post_view.dart';
import 'package:firebase_project/viewModel/auth_view_model.dart';
import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OtpVarifyView extends StatefulWidget {
  const OtpVarifyView({super.key});

  @override
  State<OtpVarifyView> createState() => _OtpVarifyViewState();
}

class _OtpVarifyViewState extends State<OtpVarifyView> {
  TextEditingController varifyCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Varification")),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          TextFormField(
            controller: varifyCode,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "Varify OTP"),
          ),
          SizedBox(height: 20.h),
          Consumer<AuthViewModel>(
            builder: (context, vm, child) {
              return RoundedButton(
                title: "Varify",
                isLoading: vm.isLoading,
                onPressed: () async {
                  final success = await vm.varifyOTP(varifyCode.text.trim());
                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => PostView()),
                      (route) => false,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
