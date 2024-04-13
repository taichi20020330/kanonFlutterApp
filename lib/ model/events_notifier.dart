import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/%20model/work_model.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/utils.dart';
import 'package:kanon_app/data/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'events_notifier.g.dart';

@riverpod
class EventsNotifier extends _$EventsNotifier {
  Map<DateTime, List<Work>> _kEventSource = {};

  @override
  LinkedHashMap<DateTime, List<Work>> build() {
    return LinkedHashMap<DateTime, List<Work>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);
  }

  void updateEvents() async {
    // List<Work> works = ref.read(workListNotifierProvider.notifier).fetchWorkListfromFirestore().value;

    // final old = AsyncValue.loading();
    // const sec3 = Duration(seconds: 3);
    // await Future.delayed(sec3);

    

  }
  


}


