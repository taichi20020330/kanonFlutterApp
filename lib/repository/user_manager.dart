import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/admin/directory_v1.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Map<int, String> _userMap = {};
  UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  Future<void> initializeUsers() async {
  try {
    await _db.collection('users').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String? userIdStr = doc.id as String?;
        String? userName = doc.data()['name'] as String?;

        if (userIdStr != null && userName != null) {
          try {
            int userId = int.parse(userIdStr);
            _userMap[userId] = userName;
          } catch (e) {
            print('Invalid user ID format: $userIdStr');
          }
        } else {
          print('User data is incomplete: ${doc.data()}');
        }
      }
    });
  } catch (e) {
    print('Error fetching users: $e');
  }
}


  String getUserName(int userId) {
    return _userMap[userId] ?? 'Unknown User'; // デフォルトの名前を返す
  }

  int getUserId(String userName) {
  try {
    return _userMap.entries
        .firstWhere((entry) => entry.value == userName)
        .key;
  } catch (e) {
    // userNameが見つからなかった場合に例外を投げる
    throw ArgumentError('User name $userName not found');
  }
}

    // すべてのユーザーを取得する関数
  Map<int, String> getAllUsers() {
    return Map.from(_userMap);
  }

  List<String> getAllUserName() {
    return _userMap.values.toList();
  }
}
