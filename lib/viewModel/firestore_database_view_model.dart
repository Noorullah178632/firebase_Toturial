import 'package:firebase_project/firebase_services/firestore_database_services.dart';
import 'package:firebase_project/utils/utils_methods.dart';
import 'package:flutter/foundation.dart';
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
  Future<bool> addData(String title) async {
    setLoading(true);
    try {
      await services.addTask(title);
      Utils().toastMessage(" Data is successfully added ", value: true);
      return true;
    } catch (e) {
      Utils().toastMessage("Failed: ${e.toString()}", value: false);
      return false;
    } finally {
      setLoading(false);
    }
  }

  //get data
  Stream<List<Map<String, dynamic>>> get streamData =>
      services.fetchStreamData();
  //update data from the services
  Future<void> updateData(String id, Map<String, dynamic> data) async {
    try {
      await services.updateData(id, data);
      Utils().toastMessage(" Data is successfully updated ", value: true);
    } catch (e) {
      Utils().toastMessage(e.toString(), value: false);
    }
  }
}
