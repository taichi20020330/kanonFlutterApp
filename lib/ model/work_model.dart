import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kanon_app/data/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'work_model.g.dart';

@riverpod
class WorkListNotifier extends _$WorkListNotifier {
  
  @override
  Future<List<Work>> build() async {
    return fetchWorkListfromFirestore();
  }

  void updateWorkList(List<Work> works) async {
    state = AsyncValue.data(works);
  }

  Future<List<Work>> fetchWorkListfromFirestore() async {
  // Firestoreからデータを取得
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('work').get();

  // データをWorkオブジェクトのリストに変換
  List<Work> works = snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data();

    DateTime date = (data['date'] as Timestamp).toDate();
    int start = extractTimeFromTimestamp(data['scheduledStartTime'] as Timestamp);
    int end = extractTimeFromTimestamp(data['scheduledEndTime'] as Timestamp);

    // Create a Work object with the parsed DateTime.
    return Work.fromJson({
      'id': doc.id,
      'date': date.toString(),
      'scheduledStartTime': start,
      'scheduledEndTime': end,
      'userId': data['userId'],
      'helperId': data['helperId'],
    });
  }).toList(); 
  state = AsyncValue.data(works);

  return works;
}
}


int extractTimeFromTimestamp(Timestamp timestamp) {
  // Convert Timestamp to DateTime
  DateTime dateTime = timestamp.toDate();

  // Extract hours and minutes and convert to int
  int time = dateTime.hour * 100 + dateTime.minute;

  return time;
}


