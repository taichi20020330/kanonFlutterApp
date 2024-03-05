import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanon_app/data/report.dart';

class ReportModel extends ChangeNotifier {
  List<Report> reports = [];

  Stream<QuerySnapshot> fetchReports() {
    final Stream<QuerySnapshot> _reportsStream =
        FirebaseFirestore.instance.collection('reports').snapshots();
    return _reportsStream;
  }

  void addReport(DateTime date, DateTime startTime, DateTime endTime, int? fee,
      String? description, int user) async {
    await FirebaseFirestore.instance
        .collection('reports') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'startTime': startTime,
      'endTime': endTime,
      'roundUpEndTime': roundTimeToNearest15Minutes(endTime),
      'fee': fee,
      'user': user,
      'description': description,
      'date': date,
    });
  }

  void removeReport(Report report) {
    FirebaseFirestore.instance.collection('reports').doc(report.id).delete();
  }

  void updateReport(Report report) {
    // state = [
    //   for (final r in state)
    //     if (r.id == report.id) report else r
    // ];
  }

  DateTime roundTimeToNearest15Minutes(DateTime time) {
    int minutes = time.hour * 60 + time.minute;
    if (minutes % 15 == 0) {
      // 指定された時間が15分単位で既に整っている場合はそのまま返す
      return time;
    } else {
      int roundedMinutes = ((minutes + 7.5) / 15).round() * 15;
      if (roundedMinutes >= 60) {
        roundedMinutes -= 60;
      }
      return DateTime(time.year, time.month, time.day, roundedMinutes ~/ 60,
          roundedMinutes % 60);
    }
  }

}