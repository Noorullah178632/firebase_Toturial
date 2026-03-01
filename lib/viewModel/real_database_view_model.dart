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
      // 1. Generate the unique reference FIRST
      final newPostRef = _instance.ref("Post").push();
      final id = newPostRef.key;
      await newPostRef
          .set({"id": id, "Data": data, "serverTime": ServerValue.timestamp})
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

  //update data
  Future<bool> updateData(String id, String newText) async {
    try {
      await _instance.ref("Post").child(id).update({
        "Data": newText,
        "serverTime": ServerValue.timestamp,
      });
      return true;
    } catch (e) {
      Utils().toastMessage("Update failed :${e.toString()}", value: false);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _instance.ref("Post").child(id).remove();
      Utils().toastMessage("Post deleted", value: true);
      return true;
    } catch (e) {
      Utils().toastMessage("Delete failed: ${e.toString()}", value: false);
      return false;
    }
  }

  // methods for search and filter the data
  String _searchQuery = "";
  void searchData(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  //no filter the data
  List filterData(Map<dynamic, dynamic> map) {
    List<dynamic> list = map.values.toList();
    if (list.isEmpty) return list;
    return list.where((item) {
      final String title = item["Data"]?.toString().toLowerCase() ?? "";

      return title.contains(_searchQuery);
    }).toList();
  }
}
