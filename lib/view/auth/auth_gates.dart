import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/view/auth/login_view.dart';
import 'package:firebase_project/view/posts/post_view.dart';
import 'package:flutter/material.dart';

class AuthGates extends StatelessWidget {
  const AuthGates({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.blue,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Connection Error")));
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const PostView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
