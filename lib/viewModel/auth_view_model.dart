import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utils/utils_methods.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  //handle loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //make instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Function for Sign UP//
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Utils().toastMessage("Successfully Signed Up", value: true);
      return true;

      // Success logic (e.g., navigating) happens in the View
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message ?? "Authentication failed");
      return false; // Return false on specific auth errors
    } catch (e) {
      Utils().toastMessage("An unexpected error occurred");
      return false; // Return false on generic errors
    } finally {
      // This runs NO MATTER WHAT (success or error)
      _setLoading(false);
    }
  }

  // Function for Login //
  Future<bool> login(final String email, final String password) async {
    _setLoading(true);

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Utils().toastMessage("Successfully Login", value: true);

      return true;

      // Success logic (e.g., navigating) happens in the View
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.message ?? "Authentication failed");

      return false; // Return false on specific auth errors
    } catch (e) {
      Utils().toastMessage("An unexpected error occurred");

      return false; // Return false on generic errors
    } finally {
      // This runs NO MATTER WHAT (success or error)
      _setLoading(false);
    }
  }

  //Funtion for sign out//
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Utils().toastMessage("Successfully Signed Out", value: true);
    } catch (e) {
      Utils().toastMessage("Log Out Failed:${e.toString()}");
    } finally {
      _setLoading(false);
    }
  }

  //phone varification //
  String? _varificationId;
  //send otp
  Future<void> sendOtp(String number, VoidCallback onCodeSend) async {
    _setLoading(true);
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          _setLoading(false);
        },
        verificationFailed: (FirebaseAuthException error) {
          _setLoading(false);
          Utils().toastMessage(error.toString());
        },
        codeSent: (String verId, int? resendToken) {
          _varificationId = verId;
          onCodeSend();
        },
        codeAutoRetrievalTimeout: (String verId) {
          _varificationId = verId;
        },
      );
    } finally {
      _setLoading(false);
    }
  }

  //Varify OTp
  Future<bool> varifyOTP(String smsCode) async {
    _setLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _varificationId!,
        smsCode: smsCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
      _setLoading(false);
      return true;
    } catch (e) {
      Utils().toastMessage("Invalid OTP");

      return false;
    } finally {
      _setLoading(false);
    }
  }
}
