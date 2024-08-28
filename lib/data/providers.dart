
import 'dart:convert';
import 'package:kanon_app/%20model/user_list_model.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/user.dart';
import 'package:kanon_app/db/database_manager.dart';
import 'package:kanon_app/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List<SingleChildWidget> independentModels = [
  Provider<DatabaseManager>(
    create: (_) => DatabaseManager(),
  ),
];

List<SingleChildWidget> dependentModels = [
  Provider<UserRepository>(
    create: (context) => UserRepository(
      dbManager: context.read<DatabaseManager>(),
    ),
  ),
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<UserListModel>(
    create: (context) => UserListModel(
      userRepository: context.read<UserRepository>(),
    )
  )
];

