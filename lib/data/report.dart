import 'package:flutter/material.dart';

@immutable
class Report {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime roundUpEndTime;
  final int? fee;
  final String? description;
  final DateTime date;
  final int user;

  Report({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.roundUpEndTime,
    this.fee,
    required this.user,
    this.description,
    required this.date,
  });
}
