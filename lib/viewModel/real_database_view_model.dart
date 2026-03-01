import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/utils/utils_methods.dart';
import 'package:flutter/material.dart';

class RealDatabaseViewModel extends ChangeNotifier {
  //handle loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //instance of realDatabase
  final FirebaseDatabase _instance = FirebaseDatabase.instance;
  // Inside RealDatabaseViewModel
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("Post");
  //to get data we use streams
  Stream<DatabaseEvent> get streamData => _dbRef.onValue;

  //make function to add data in real data base
  Future<bool> addData(String data) async {
    _setLoading(true);
    try {
      await _instance
          .ref("Post")
          .push()
          .set({"Data": data, "serverTime": ServerValue.timestamp})
          .then((value) {
            Utils().toastMessage("Data added successfully", value: true);
          });
      return true;
    } catch (e) {
      Utils().toastMessage(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
