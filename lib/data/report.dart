import 'package:flutter/material.dart';
import 'package:kanon_app/data/work_cateogory.dart';

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
  final Map<String, dynamic>? workCategory;
  
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
    this.workCategory, 
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'roundUpEndTime': roundUpEndTime,
      'fee': fee,
      'user': user,
      'helperId': helperId,
      'description': description,
      'date': date,
      'deleteFlag': deleteFlag,
      'commutingRoute': commutingRoute,
      'breakTime': breakTime,
      'workCategory': workCategory,
    };
  }
  

  Report copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? roundUpEndTime,
    int? fee,
    int? user,
    String? helperId,
    String? description,
    DateTime? date,
    bool? deleteFlag,
    String? commutingRoute,
    int? breakTime,
    Map<String, dynamic>? workCategory,
  }) {
    return Report(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      roundUpEndTime: roundUpEndTime ?? this.roundUpEndTime,
      fee: fee ?? this.fee,
      user: user ?? this.user,
      helperId: helperId ?? this.helperId,
      description: description ?? this.description,
      date: date ?? this.date,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      commutingRoute: commutingRoute ?? this.commutingRoute,
      breakTime: breakTime ?? this.breakTime,
      workCategory: workCategory ?? this.workCategory,
    );
  }

}
