import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:kanon_app/%20model/work_notifier.dart';
import 'package:kanon_app/data/report.dart';

class ReportModel extends ChangeNotifier {

  final workListProvider = WorkListNotifier();
  List<Report> reports = [];

  Stream<QuerySnapshot> fetchReports() {
    final Stream<QuerySnapshot> _reportsStream =
        FirebaseFirestore.instance.collection('reports').snapshots();
    return _reportsStream;
  }

  void addReport(DateTime date, DateTime startTime, DateTime endTime, int? fee,
      String? description, int user, String helperId, int breakTime, String commutingRoute) async {
    await FirebaseFirestore.instance
        .collection('reports') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'startTime': startTime,
      'endTime': endTime,
      'roundUpEndTime': roundTimeToNearest15Minutes(endTime),
      'fee': fee,
      'user': user,
      'helperId': helperId,
      'description': description,
      'date': date,
      'breakTime': breakTime,
      'commutingRoute' : commutingRoute,
      'deleteFlag': false,
    });
  }

  void addRelatedReport(DateTime date, DateTime startTime, DateTime endTime,
      int? fee, String? description, int user, String helperId, String workId, int breakTime, String commutingRoute ) async {
    final docRef = await FirebaseFirestore.instance
        .collection('reports') // コレクションID指定
        .doc(); // ドキュメントID自動生成

    final docId = docRef.id;

    await docRef.set({
      'startTime': startTime,
      'endTime': endTime,
      'roundUpEndTime': roundTimeToNearest15Minutes(endTime),
      'fee': fee,
      'user': user,
      'helperId': helperId,
      'description': description,
      'date': date,
      'breakTime': breakTime,
      'commutingRoute' : commutingRoute,
      'deleteFlag': false,
    });

    // linkReportidWithWork(docId, workId);
  }

  void removeReport(Report report) {
    FirebaseFirestore.instance.collection('reports').doc(report.id).update({
      'deleteFlag': true,
  });
  }
  void updateReport(String id, DateTime date, DateTime startTime,
      DateTime endTime, int? fee, String? description, int user, String helperId,  int breakTime, String commutingRoute) async {
    await FirebaseFirestore.instance.collection('reports').doc(id).update({
      'startTime': startTime,
      'endTime': endTime,
      'roundUpEndTime': roundTimeToNearest15Minutes(endTime),
      'fee': fee,
      'user': user,
      'helperId' : helperId,
      'description': description,
      'date': date,
      'breakTime': breakTime,
      'commutingRoute' : commutingRoute,
    });
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

  // void linkReportidWithWork (String reportId, String workId) {
  //   // fetchWorkFromId
  //   workListProvider.linkReportidWithWork(reportId, workId);
  // }
}
