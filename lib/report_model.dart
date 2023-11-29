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
}
