// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/%20model/events_notifier.dart';
import 'package:kanon_app/%20model/work_notifier.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/provider.dart';
import 'package:kanon_app/data/work.dart';
import 'package:kanon_app/page/schedule_list_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/utils.dart';

// Map<DateTime, List<Work>> kEvents = LinkedHashMap<DateTime, List<Work>>(
//       equals: isSameDay,
//       hashCode: getHashCode,
//     )..addAll(_kEventSource);

Map<DateTime, List<Work>> kEvents = {};
Map<DateTime, List<Work>> _kEventSource = {};

class TableEventsExample extends ConsumerStatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<TableEventsExample> {
  final db = FirebaseFirestore.instance;
  late final ValueNotifier<List<Work>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Work> currentWorkList = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _initializeData();
  }

  Future<void> _initializeData() async {
    currentWorkList =
        await ref.read(workListNotifierProvider.notifier).updateWorkList();
    for (final work in currentWorkList) {
      _addWorkToEventSource(work);
      _addEventSourceToCalendar();
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final works = ref.watch(workListNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('勤務カレンダー'),
        ),
        body: works.when(
          data: (workList) {
            return Column(
              children: [
                CalendarWidget(),
                const SizedBox(height: 8.0),
                EventListUnderCalendar(workList),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () async {
            kEvents.clear();
            _kEventSource.clear();
            final notifier = ref.read(workListNotifierProvider.notifier);
            currentWorkList = await notifier.updateWorkList();
            _refreshEventList(currentWorkList);
          },
        ));
  }

  Widget EventListUnderCalendar(List<Work> workList) {
    return Expanded(
      // return (_isloading)
      //     ? const CircularProgressIndicator()
      //     : Expanded(
      child: ValueListenableBuilder<List<Work>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final work = value[index];
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  // userIdからuserNameに変換
                  title: Text(
                    convertUserIdToUserName(work.userId),
                  ),
                  // startTimeとendTimeを時刻表示に変換
                  subtitle: Text(
                    '${convertToTimeFormat(work.scheduledStartTime)} - ${convertToTimeFormat(work.scheduledEndTime)}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget CalendarWidget() {
    return TableCalendar<Work>(
      locale: 'ja_JP',
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        // Use `CalendarStyle` to customize the UI
        outsideDaysVisible: false,
      ),
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  List<Work> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Work> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  void _addWorkToEventSource(Work work) {
    final id = work.id;
    final date = work.date;
    final existingEvents = _kEventSource[date] ?? [];

    final isDuplicate =
        existingEvents.any((existingWork) => existingWork.id == id);
    if (!isDuplicate) {
      _kEventSource[date] = [...existingEvents, work];
    }
  }

  void _addEventSourceToCalendar() {
    kEvents = LinkedHashMap<DateTime, List<Work>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);
  }

  void _refreshEventList(List<Work> works) async {
    for (final work in works) {
      _addWorkToEventSource(work);
    }
    _addEventSourceToCalendar();
    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }
}