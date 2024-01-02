// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkImpl _$$WorkImplFromJson(Map<String, dynamic> json) => _$WorkImpl(
      id: json['id'] as String,
      date: json['date'] as DateTime,
      scheduledStartTime: json['scheduledStartTime'] as int,
      scheduledEndTime: json['scheduledEndTime'] as int,
      userId: json['userId'] as int,
      helperId: json['helperId'] as int,
    );

Map<String, dynamic> _$$WorkImplToJson(_$WorkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'scheduledStartTime': instance.scheduledStartTime,
      'scheduledEndTime': instance.scheduledEndTime,
      'userId': instance.userId,
      'helperId': instance.helperId,
    };
