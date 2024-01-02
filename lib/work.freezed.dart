// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Work _$WorkFromJson(Map<String, dynamic> json) {
  return _Work.fromJson(json);
}

/// @nodoc
mixin _$Work {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get scheduledStartTime => throw _privateConstructorUsedError;
  int get scheduledEndTime => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  int get helperId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkCopyWith<Work> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkCopyWith<$Res> {
  factory $WorkCopyWith(Work value, $Res Function(Work) then) =
      _$WorkCopyWithImpl<$Res, Work>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      int scheduledStartTime,
      int scheduledEndTime,
      int userId,
      int helperId});
}

/// @nodoc
class _$WorkCopyWithImpl<$Res, $Val extends Work>
    implements $WorkCopyWith<$Res> {
  _$WorkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? scheduledStartTime = null,
    Object? scheduledEndTime = null,
    Object? userId = null,
    Object? helperId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledEndTime: null == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      helperId: null == helperId
          ? _value.helperId
          : helperId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkImplCopyWith<$Res> implements $WorkCopyWith<$Res> {
  factory _$$WorkImplCopyWith(
          _$WorkImpl value, $Res Function(_$WorkImpl) then) =
      __$$WorkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      int scheduledStartTime,
      int scheduledEndTime,
      int userId,
      int helperId});
}

/// @nodoc
class __$$WorkImplCopyWithImpl<$Res>
    extends _$WorkCopyWithImpl<$Res, _$WorkImpl>
    implements _$$WorkImplCopyWith<$Res> {
  __$$WorkImplCopyWithImpl(_$WorkImpl _value, $Res Function(_$WorkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? scheduledStartTime = null,
    Object? scheduledEndTime = null,
    Object? userId = null,
    Object? helperId = null,
  }) {
    return _then(_$WorkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledStartTime: null == scheduledStartTime
          ? _value.scheduledStartTime
          : scheduledStartTime // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledEndTime: null == scheduledEndTime
          ? _value.scheduledEndTime
          : scheduledEndTime // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      helperId: null == helperId
          ? _value.helperId
          : helperId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkImpl implements _Work {
  _$WorkImpl(
      {required this.id,
      required this.date,
      required this.scheduledStartTime,
      required this.scheduledEndTime,
      required this.userId,
      required this.helperId});

  factory _$WorkImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final int scheduledStartTime;
  @override
  final int scheduledEndTime;
  @override
  final int userId;
  @override
  final int helperId;

  @override
  String toString() {
    return 'Work(id: $id, date: $date, scheduledStartTime: $scheduledStartTime, scheduledEndTime: $scheduledEndTime, userId: $userId, helperId: $helperId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.scheduledStartTime, scheduledStartTime) ||
                other.scheduledStartTime == scheduledStartTime) &&
            (identical(other.scheduledEndTime, scheduledEndTime) ||
                other.scheduledEndTime == scheduledEndTime) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.helperId, helperId) ||
                other.helperId == helperId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, scheduledStartTime,
      scheduledEndTime, userId, helperId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkImplCopyWith<_$WorkImpl> get copyWith =>
      __$$WorkImplCopyWithImpl<_$WorkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkImplToJson(
      this,
    );
  }
}

abstract class _Work implements Work {
  factory _Work(
      {required final String id,
      required final DateTime date,
      required final int scheduledStartTime,
      required final int scheduledEndTime,
      required final int userId,
      required final int helperId}) = _$WorkImpl;

  factory _Work.fromJson(Map<String, dynamic> json) = _$WorkImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  int get scheduledStartTime;
  @override
  int get scheduledEndTime;
  @override
  int get userId;
  @override
  int get helperId;
  @override
  @JsonKey(ignore: true)
  _$$WorkImplCopyWith<_$WorkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
