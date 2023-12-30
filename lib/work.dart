
import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'work.freezed.dart';
part 'work.g.dart';



/// The response of the `GET /api/activity` endpoint.
///
/// It is defined using `freezed` and `json_serializable`.
@freezed
class Work with _$Work {
  factory Work({
  required String id,
  required String date,
  required int scheduledStartTime,
  required int scheduledEndTime,
  required int userId,
  required int helperId,
  }) = _Work;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorkFromJson(json);
}



// class Work {
  

//   Work({
//     required this.id,
//     required this.date,
//     required this.scheduledStartTime,
//     required this.scheduledEndTime,
//     required this.userId,
//     required this.helperId,
//   });

//   factory Work.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'id': String id,
//         'date': DateTime date,
//         'scheduledStartTime': String scheduledStartTime,
//         'scheduledEndTime': String scheduledEndTime,
//         'userId': int userId,
//         'helperId': int helperId,
//       } =>
//         Work(
//           id: id,
//           date: date,
//           scheduledStartTime: scheduledStartTime,
//           scheduledEndTime: scheduledEndTime,
//           userId: userId,
//           helperId: helperId,
//         ),
//       _ => throw const FormatException('Failed to load album.'),
//     };
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date,
//       'scheduledStartTime': scheduledStartTime,
//       'scheduledEndTime': scheduledEndTime,
//       'userId': userId,
//       'helperId': helperId,
//     };
//   }
// }
