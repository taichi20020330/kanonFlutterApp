// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/work.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.


/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Work>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

Map<DateTime, List<Work>> _kEventSource = {};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

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