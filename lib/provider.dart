
import 'dart:convert';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'provider.g.dart';

@riverpod
Future<List<Work>> works(WorksRef ref) async {
  // Using package:http, we fetch a random activity from the Bored API.
  final response = await http.get(Uri.https('api.sssapi.app', 'h6y_ywkD7tbejTS7XcDLT'));
  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  List<dynamic> jsonList = jsonDecode(response.body);
  List<Work> works = jsonList.map((json) => Work.fromJson(json as Map<String, dynamic>)).toList();
  return works;
}


class PageNotifier extends Notifier<PageType> {
  
  @override
  build() {
    return PageType.Report;  // 最初に表示するページを設定
  }

  // タブが切り替わった時に呼ばれる
  void changePage(PageType pageType) {
    state = pageType;
  }
}