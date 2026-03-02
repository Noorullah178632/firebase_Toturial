import 'package:firebase_project/firebase_services/firestore_database_services.dart';
import 'package:flutter/material.dart';

class FirestoreDatabaseViewModel extends ChangeNotifier {
  //make instance of firestore database services
  FirestoreDatabaseServices services = FirestoreDatabaseServices();
  //set Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Add Function
}
