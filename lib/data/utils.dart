// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/work.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 1, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 1, kToday.day);

final Map<String, int> helperIdMappingList = {
  'nnnnnnnnnnnnnnnnnnnnnnnnnnnn': 0,
  'tic57NzS85ROCWbJ5PXk8v3MSYI3': 1,
  '3iMEqgbH3YM9lbNVBY83CbAXMxS2': 2,
  'NyGgvA2FJ1VLcphr4jTchY9lAOw1': 3,
};

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
String convertUserIdToUserName(int id) {
    // simpleUserNameListのid番目の要素を返す
    return simpleUserNameList[id];
  }

String convertToTimeFormat(int input) {
    // 桁数が足りない場合はエラーとしてnullを返す
    if (input < 100 || input > 2359) {
      return "";
    }

    // 入力された数字から時と分を取得
    int hour = input ~/ 100;
    int minute = input % 100;

    // 時と分が適切な範囲か確認
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return "";
    }

    // 時間と分をフォーマットして返す
    return '${hour.toString()}:${minute.toString().padLeft(2, '0')}';
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}


int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


int extractTimeFromTimestamp(Timestamp timestamp) {
  // Convert Timestamp to DateTime
  DateTime dateTime = timestamp.toDate();

  // Extract hours and minutes and convert to int
  int time = dateTime.hour * 100 + dateTime.minute;

  return time;
}
