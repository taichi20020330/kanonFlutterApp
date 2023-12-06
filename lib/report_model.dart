import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';
import 'report.dart';

const _uuid = Uuid();


class ReportModel extends Notifier<List<Report>> {
  @override
  List<Report> build() => [
        Report(
          startTime: TimeOfDay(hour: 9, minute: 0),
          endTime: TimeOfDay(hour: 17, minute: 0),
          roundUpEndTime: roundTimeToNearest15Minutes(TimeOfDay(hour: 17, minute: 13)),
          fee: 500,
          user: 1,
          date: DateTime(2021, 10, 1), 
          id: _uuid.v4(),
        ),
      ];

  void addReport(DateTime date, TimeOfDay startTime, TimeOfDay endTime,
      int? fee, String? description, int user) {
    state = [
      ...state,
      Report(
        id: _uuid.v4(),
        startTime: startTime,
        endTime: endTime,
        roundUpEndTime: roundTimeToNearest15Minutes(endTime),
        fee: fee,
        user: user,
        description: description,
        date: date,
      )
    ];
  }

  void removeReport(Report report) {
    state = state.where((element) => element.id != report.id).toList();
  }

  void updateReport(Report report) {
    state = [
      for (final r in state)
        if (r.id == report.id) report else r
    ];
  }

  TimeOfDay roundTimeToNearest15Minutes(TimeOfDay time) {
  int minutes = time.hour * 60 + time.minute;
  if (minutes % 15 == 0) {
    // 指定された時間が15分単位で既に整っている場合はそのまま返す
    return time;
  } else {
    int roundedMinutes = ((minutes + 7.5) / 15).round() * 15;
    if (roundedMinutes >= 60) {
      roundedMinutes -= 60;
    }
    return TimeOfDay(hour: roundedMinutes ~/ 60, minute: roundedMinutes % 60);
  }
}

}
