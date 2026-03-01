import 'package:firebase_project/view/auth/otp_varify_view.dart';
import 'package:firebase_project/viewModel/auth_view_model.dart';
import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({super.key});

  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  TextEditingController phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication")),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          TextFormField(
            controller: phoneNumber,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "+1 234 567 789"),
          ),
          SizedBox(height: 20.h),
          Consumer<AuthViewModel>(
            builder: (context, vm, child) {
              return RoundedButton(
                isLoading: vm.isLoading,
                title: "Login",
                onPressed: () {
                  vm.sendOtp(phoneNumber.text.trim(), () {
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OtpVarifyView()),
                    );
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
