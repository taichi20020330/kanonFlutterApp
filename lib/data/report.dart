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
  final String helperId;
  final String? commutingRoute;
  final int? breakTime;
  final bool deleteFlag;

  const Report({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.roundUpEndTime,
    this.fee,
    required this.user,
    required this.helperId,
    this.description,
    this.breakTime,
    required this.date,
    required this.deleteFlag,
    this.commutingRoute,
  });
}
