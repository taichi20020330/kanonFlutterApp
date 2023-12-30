import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/work.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';


class WorkModel extends Notifier<List<Work>> {
  @override
  List<Work> build() => [
        
      ];

//   Future<List<Work>> fetchWorks() async {
//   final response = await http.get(Uri.parse('https://api.sssapi.app/h6y_ywkD7tbejTS7XcDLT'));
//   if (response.statusCode == 200) {
//     // サーバーが 200 OK レスポンスを返した場合、JSON 配列をパースします。
//     List<dynamic> jsonList = jsonDecode(response.body);
//     List<Work> works = jsonList.map((json) => Work.fromJson(json as Map<String, dynamic>)).toList();
//     return works;
//   } else {
//     // サーバーが 200 OK レスポンスを返さなかった場合は例外をスローします。
//     throw Exception('作業の読み込みに失敗しました');
//   }
// }



}
