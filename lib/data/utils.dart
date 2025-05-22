// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/data/work.dart';


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


Duration calculateTotalWorkTime(List<Report> reports) {
  return reports.fold(Duration.zero, (previous, report) {
    DateTime startTime =
        DateTime(2023, 1, 1, report.startTime.hour, report.startTime.minute);
    DateTime endTime = DateTime(
        2023, 1, 1, report.roundUpEndTime.hour, report.roundUpEndTime.minute);
    Duration workDuration = endTime.difference(startTime);

    int breakMinutes = report.breakTime ?? 0;
    Duration actualWork = workDuration - Duration(minutes: breakMinutes);

    if (actualWork.isNegative) actualWork = Duration.zero;

    return previous + actualWork;
  });
}

double calculateMonthlySalary(Duration totalWorkTime) {
  const hourlyWage = 1200.0; // 時給
  double totalWorkHours = totalWorkTime.inMinutes / 60.0;
  return totalWorkHours * hourlyWage;
}

DateTime roundTimeToNearest15Minutes(DateTime time) {
    int minutes = time.hour * 60 + time.minute;
    if (minutes % 15 == 0) {
      // 指定された時間が15分単位で既に整っている場合はそのまま返す
      return time;
    } else {
      // 繰上げを行うため、(minutes + 14) / 15 の整数部分を計算し、それを15倍することで15分単位に繰上げ
      int roundedMinutes = ((minutes + 14) ~/ 15) * 15;
      int hours = roundedMinutes ~/ 60;
      int mins = roundedMinutes % 60;

      // hoursが24以上の場合を考慮
      if (hours >= 24) {
        hours -= 24;
        return DateTime(time.year, time.month, time.day + 1, hours, mins);
      } else {
        return DateTime(time.year, time.month, time.day, hours, mins);
      }
    }
  }

