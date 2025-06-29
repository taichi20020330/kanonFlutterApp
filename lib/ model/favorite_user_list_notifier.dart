import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/data/user.dart';

class FavoriteUserListNotifier extends StateNotifier<List<User>> {
    FavoriteUserListNotifier() : super([]);
    
    void addUser(User user) {
    if (!state.contains(user)) {
      state = [...state, user];
    }
  }

  void removeUser(User user) {
    state = state.where((u) => u.id != user.id).toList();
  }
  
}