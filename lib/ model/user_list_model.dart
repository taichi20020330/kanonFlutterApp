import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/data/user.dart';
import 'package:kanon_app/repository/user_repository.dart';

class UserListModel extends ChangeNotifier {
  final UserRepository userRepository;
  bool isProcessing = false;
  UserListModel({required this.userRepository});
  List<User> users = [];

  Future<List<User>> getUsers() async {
    isProcessing = true;
    notifyListeners();

    users = await userRepository.getUsers();

    isProcessing = false;
    notifyListeners();
    return users;
  }

  List<String> get userNames {
    final results = users.map((user) => user.name).toList();
    // もし空だったらエラー
    if (results.isEmpty) {
      throw Exception('ユーザーが見つかりません');
    }
    return results;
    
  }

  String convertUserIdToUserName(int userId) {
    final user = users.firstWhere((user) => user.id == userId);
    if (user == null) {
      throw Exception('ユーザーが見つかりません');
    }
    return user.name;
  }

  int convertUserNameToUserId(String userName) {
    final user = users.firstWhere((user) => user.name == userName);
    if (user == null) {
      throw Exception('ユーザーが見つかりません');
    }
    return user.id;
  }
}

