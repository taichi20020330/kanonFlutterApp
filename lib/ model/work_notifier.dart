import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kanon_app/data/utils.dart';
import 'package:kanon_app/data/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'work_notifier.g.dart';

@riverpod
class WorkListNotifier extends _$WorkListNotifier {
  List<Work> works = [];


  @override
  Future<List<Work>> build() async {
    return fetchWorkListfromFirestore();
  }

  Future<List<Work>> fetchWorkListfromFirestore() async {
    // Firestoreからデータを取得
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('work').get();

    // データをWorkオブジェクトのリストに変換
    works = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();

      DateTime date = (data['date'] as Timestamp).toDate();
      int start =
          extractTimeFromTimestamp(data['scheduledStartTime'] as Timestamp);
      int end = extractTimeFromTimestamp(data['scheduledEndTime'] as Timestamp);

      // Create a Work object with the parsed DateTime.
      return Work.fromJson({
        'id': doc.id,
        'date': date.toString(),
        'scheduledStartTime': start,
        'scheduledEndTime': end,
        'userId': data['userId'],
        'helperId': data['helperId'],
        'reportId': data['reportId']
      });
    }).toList();
    state = AsyncValue.data(works);

    return works;
  }

  Future<List<Work>> updateWorkList() async {
    works = await fetchWorkListfromFirestore();
    state = AsyncValue.data(works);
    return works;

  }


  void linkReportidWithWork(String reportId, String workId) async {
    await FirebaseFirestore.instance.collection('work').doc(workId).update({
      'reportId':  reportId
    });
  }


}
