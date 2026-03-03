import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseServices {
  //make instance for firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //add function
  Future<void> addTask(String title) async {
    await _db.collection("User Data").add({"title": title.toString()});
  }

  //fetch data
  Stream<List<Map<String, dynamic>>> fetchStreamData() {
    return _db.collection("User Data").snapshots().map((snap) {
      return snap.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        }; //"title":doc["title"] ,,if incase we want to get a specific field
      }).toList();
    });
  }

  //we can also get the firestore data base data using like that : .collection("user Data").snapshot(),, but the thing is if we wanna filter data then we move toward the mapping method
}
