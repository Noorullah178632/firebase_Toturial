import 'package:firebase_project/view/auth/phone_login_view.dart';
import 'package:firebase_project/view/auth/signup_view.dart';
import 'package:firebase_project/view/posts/post_view.dart';
import 'package:firebase_project/viewModel/auth_view_model.dart';
import 'package:firebase_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //value Notifier
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  //dispose method
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _obscurePassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: emailController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  suffixIcon: Icon(Icons.email, size: 20.sp),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 15.h,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Please enter email";
                  if (!value.endsWith("@gmail.com")) {
                    return "Please enter valid email";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              // Password Field
              ValueListenableBuilder<bool>(
                valueListenable: _obscurePassword,
                builder: (context, v, child) {
                  return TextFormField(
                    controller: passwordController,
                    obscureText: v,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 14.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          v ? Icons.visibility_off : Icons.visibility,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _obscurePassword.value = !_obscurePassword.value;
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Please enter password";
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  );
                },
              ),

              SizedBox(height: 30.h),

              // Show loader or button
              Consumer<AuthViewModel>(
                builder: (context, vm, child) {
                  return RoundedButton(
                    title: "Login",
                    isLoading: vm.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await vm.login(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                        if (!context.mounted) return;
                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => PostView()),
                            (predicate) => (false),
                          );
                        }
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PhoneLoginView()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: Colors.black),
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Text(
                      "Login with phone",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              Row(
                mainAxisAlignment: .center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpView()),
                      );
                    },
                    child: Text("SignUp"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
