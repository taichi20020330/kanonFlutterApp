import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kanon_app/data/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'work_model.g.dart';

class WorkModel extends Notifier<List<Work>> {
  @override
  List<Work> build() => [];
}

@riverpod
Future<List<Work>> works(WorksRef ref) async {
  // Using package:http, we fetch a random activity from the Bored API.
  final response = await http.get(Uri.https('api.sssapi.app', 'un4YOrTFzJOmeag_VJlNs'));
  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  List<dynamic> jsonList = jsonDecode(response.body);
  List<Work> works = jsonList.map((json) {
      // Use parseJapaneseDate to convert the date string to DateTime.
      String parsedDate = parseJapaneseDate(json['date'] as String);
      
      // Create a Work object with the parsed DateTime.
      return Work.fromJson({
        ...json,
        'date': parsedDate,
      });
    }).toList();
  return works;
}

String parseJapaneseDate(String dateString) {
  List<String> parts = dateString.split('/');
  if (parts.length == 3) {
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    String date = DateTime(year, month, day).toString();
    
    return date;
  } else {
    throw FormatException("Invalid date format: $dateString");
  }
}

