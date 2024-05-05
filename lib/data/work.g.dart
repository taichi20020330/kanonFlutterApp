// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkImpl _$$WorkImplFromJson(Map<String, dynamic> json) => _$WorkImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      scheduledStartTime: json['scheduledStartTime'] as int,
      scheduledEndTime: json['scheduledEndTime'] as int,
      userId: json['userId'] as int,
      helperId: json['helperId'] as int,
      reportId: json['reportId'] as String? ?? "",
    );

Map<String, dynamic> _$$WorkImplToJson(_$WorkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'scheduledStartTime': instance.scheduledStartTime,
      'scheduledEndTime': instance.scheduledEndTime,
      'userId': instance.userId,
      'helperId': instance.helperId,
      'reportId': instance.reportId,
    };
