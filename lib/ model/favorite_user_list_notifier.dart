import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kanon_app/data/user.dart' as data;
import 'package:kanon_app/repository/user_manager.dart';

class FavoriteUserListNotifier extends StateNotifier<List<data.User>> {
  FavoriteUserListNotifier() : super([]) {
    loadFavoriteUsers();
  }

  final UserManager userManager = UserManager();

  Future<void> loadFavoriteUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favorite_users') ?? [];

    final allUsers = userManager.getAllUsers(); // Map<int, String>
    final favorites = <data.User>[];

    for (final idStr in ids) {
      final id = int.tryParse(idStr);
      if (id != null && allUsers.containsKey(id)) {
        favorites.add(data.User(id: id, name: allUsers[id]!));
      }
    }

    state = favorites;
  }

  Future<void> addUser(data.User user) async {
    if (state.any((u) => u.id == user.id)) return; // すでに登録済みなら追加しない
    state = [...state, user];
    await saveToPrefs();
  }

  Future<void> removeUser(data.User user) async {
    state = state.where((u) => u.id != user.id).toList();
    await saveToPrefs();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = state.map((u) => u.id.toString()).toList();
    await prefs.setStringList('favorite_users', ids);
  }
}
