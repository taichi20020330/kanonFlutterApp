import 'package:flutter/material.dart';
import 'package:kanon_app/data/user.dart';
import 'package:kanon_app/repository/user_repository.dart';

class UserListModel extends ChangeNotifier {
  final UserRepository userRepository;
    bool isProcessing = false;

  UserListModel({required this.userRepository});
  List<User> users = [];

  Future<void> getUsers() async {
    isProcessing = true;
    notifyListeners();

    users = await userRepository.getUsers();

    isProcessing = false;
    notifyListeners();
  }

  List<String> get userNames {
    return users.map((user) => user.name).toList();
  }

  

}