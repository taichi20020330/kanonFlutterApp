import 'package:kanon_app/data/user.dart';
import 'package:kanon_app/repository/user_manager.dart';
import 'package:riverpod/riverpod.dart';

class UserListNotifier extends StateNotifier<List<User>>{

  UserListNotifier() : super([]) {
    _loadUsers();
  }

  bool isProcessing = false;
  Future<void> _loadUsers() async {
    isProcessing = true;
    await UserManager().initializeUsers();

    final Map<int, String> userMap = UserManager().getAllUsers();
    state = userMap.entries.map((entry) => User(id: entry.key, name: entry.value))
        .toList();

    isProcessing = false;
  }

  List<String> get userNames {
    if (state.isEmpty) {
      throw Exception('ユーザーが見つかりません');
    }
    return state.map((user) => user.name).toList();
  }

  String convertUserIdToUserName(int userId) {
    final user = state.firstWhere((u) => u.id == userId, orElse: () => throw Exception('ユーザーが見つかりません'));
    return user.name;
  }

  int convertUserNameToUserId(String userName) {
    final user = state.firstWhere((u) => u.name == userName, orElse: () => throw Exception('ユーザーが見つかりません'));
    return user.id;
  }
}