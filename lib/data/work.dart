
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:kanon_app/data/utils.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:http/http.dart' as http;
// part 'work.freezed.dart';
// part 'work.g.dart';

// @freezed
// class Work with _$Work {
//   factory Work({
//   required String id,
//   required DateTime date,
//   required int scheduledStartTime,
//   required int scheduledEndTime,
//   required int userId,
//   required String helperId,
//   required bool isReported
//   }) = _Work;

//   /// Convert a JSON object into an [Activity] instance.
//   /// This enables type-safe reading of the API response.
//   factory Work.fromJson(Map<String, dynamic> json) =>
//       _$WorkFromJson(json);

//   // fromFirestore 関数
//   factory Work.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//       DateTime date = (data['date'] as Timestamp).toDate();
//       int start =
//           extractTimeFromTimestamp(data['scheduledStartTime'] as Timestamp);
//       int end = extractTimeFromTimestamp(data['scheduledEndTime'] as Timestamp);

//       // Create a Work object with the parsed DateTime.
//       return Work.fromJson({
//         'id': doc.id,
//         'date': date.toString(),
//         'scheduledStartTime': start,
//         'scheduledEndTime': end,
//         'userId': data['userId'],
//         'helperId': data['helperId'],
//         'isReported': data['isReported']
//       });
//   }

  
// }


