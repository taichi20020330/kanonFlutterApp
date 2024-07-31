
import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'work.freezed.dart';
part 'work.g.dart';

@freezed
class Work with _$Work {
  factory Work({
  required String id,
  required DateTime date,
  required int scheduledStartTime,
  required int scheduledEndTime,
  required int userId,
  required String helperId,
  required bool isReported
  }) = _Work;

  /// Convert a JSON object into an [Activity] instance.
  /// This enables type-safe reading of the API response.
  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorkFromJson(json);
}

