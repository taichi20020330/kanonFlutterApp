// import 'dart:collection';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kanon_app/%20model/work_notifier.dart';
// import 'package:kanon_app/data/enum.dart';
// import 'package:kanon_app/data/utils.dart';
// import 'package:kanon_app/data/work.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:table_calendar/table_calendar.dart';

// part 'events_notifier.g.dart';

// @riverpod
// class EventsNotifier extends _$EventsNotifier {
  
//   @override
//   Map<DateTime, List<Work>> build() {
//     final Map<DateTime, List<Work>> events = {};

//     return LinkedHashMap<DateTime, List<Work>>(
//       equals: isSameDay,
//       hashCode: getHashCode,
//     )..addAll(events);
//   }

//   void addEvents(List<Work> works) {
//     final events = state;
//     for (final work in works) {
//       final date = work.date;
//       final id = work.id;

//       // Check if the event with the same date and title already exists
//       final existingEvents = events[date] ?? [];
//       final isDuplicate =
//           existingEvents.any((existingWork) => existingWork.id == id);

//       if (!isDuplicate) {
//         events[date] = [...existingEvents, work];
//       }
//     }
//     state = events;
//   }

//   void updateEvents(List<Work> works) async {
//     // // 今までのやつをを取得

//     // state = oldEvents;

//     // final newWorks = await ref.read(workListNotifierProvider.notifier).fetchWorkListfromFirestore();

//     // for (final work in newWorks) {
//     //   addWorkEvents(work);
//     // }
//   }
// }
