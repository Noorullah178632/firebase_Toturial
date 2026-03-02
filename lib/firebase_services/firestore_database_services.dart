import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseServices {
  //make instance for firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //add function
  Future<void> addTask(String title) async {
    await _db.collection("User Data").add({"title": title.toString()});
  }
}
