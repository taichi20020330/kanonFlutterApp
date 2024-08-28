import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanon_app/data/user.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // firebaseの接点となるコードは全部ここに書く
  Future<List<User>> getUsers() async {
    var results = <User>[];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').get();
        results = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();

      return User.fromMap({
        'id': doc.id,
        'name': data['name'],
      });
    }).toList();
    return results;
  }

}
