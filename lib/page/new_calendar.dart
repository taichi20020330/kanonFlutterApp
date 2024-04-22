// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanon_app/data/utils.dart';
import 'package:kanon_app/data/work.dart';
import 'package:table_calendar/table_calendar.dart';

Map<DateTime, List<Work>> kEvents = {};
Map<DateTime, List<Work>> _kEventSource = {};

class NewCalendar extends StatefulWidget {
  @override
  _NewCalendarState createState() => _NewCalendarState();
}

class _NewCalendarState extends State<NewCalendar> {
  late final ValueNotifier<List<Work>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    Future(() async {
      List<Work> works = await fetchWorkList();
      for (final work in works) {
      _addWorkToEventSource(work);
    }
    });
  
    kEvents = LinkedHashMap<DateTime, List<Work>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Work>(
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
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Work>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
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
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addWorkToEventSource(Work work) {
    final date = work.date;
    final id = work.id;

    // Check if the event with the same date and title already exists
    final existingEvents = _kEventSource[date] ?? [];
    final isDuplicate =
        existingEvents.any((existingWork) => existingWork.id == id);

    if (!isDuplicate) {
      _kEventSource[date] = [...existingEvents, work];
    }
  }
}

Future<List<Work>> fetchWorkList() async {
  // Firestoreからデータを取得
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('work').get();

  // データをWorkオブジェクトのリストに変換
  List<Work> works = snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data();

    DateTime date = (data['date'] as Timestamp).toDate();
    int start =
        extractTimeFromTimestamp(data['scheduledStartTime'] as Timestamp);
    int end = extractTimeFromTimestamp(data['scheduledEndTime'] as Timestamp);

    // Create a Work object with the parsed DateTime.
    return Work.fromJson({
      'id': doc.id,
      'date': date.toString(),
      'scheduledStartTime': start,
      'scheduledEndTime': end,
      'userId': data['userId'],
      'helperId': data['helperId'],
    });
  }).toList();

  return works;
}
