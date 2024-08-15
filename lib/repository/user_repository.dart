
import 'package:kanon_app/data/user.dart';
import 'package:kanon_app/db/database_manager.dart';

class UserRepository {
  final DatabaseManager dbManager;

  UserRepository({required this.dbManager});
  
  Future<List<User>> getUsers() async {
    return dbManager.getUsers();
  }

}