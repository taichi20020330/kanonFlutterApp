import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Report {
  final String id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int? fee;
  final String? description;
  final DateTime date;
  final int user;

  Report({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.fee,
    required this.user,
    this.description,
    required this.date,
  });
}