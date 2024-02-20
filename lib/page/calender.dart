// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/%20model/work_model.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/provider.dart';
import 'package:kanon_app/data/work.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/utils.dart';

class TableEventsExample extends ConsumerStatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<TableEventsExample> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    ref.read(worksProvider);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  late final ValueNotifier<List<Work>> _selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Work>> works = ref.watch(worksProvider);

    works.when(
      data: (worksList) {
        // if (!listEquals(worksList, previousWorks)) {
        //   for (var work in worksList) {
        //     String title = '${convertUserIdToUserName(work.userId)} '
        //         ' ${convertToTimeFormat(work.scheduledStartTime)}';
        //     scheduleList.add({
        //       'datetime': work.date,
        //       'title': title,
        //     });
        //   }
        // }
        // previousWorks = worksList;
        for (var work in worksList) {
          final date = work.date;
          final id = work.id;

          // Check if the event with the same date and title already exists
          final existingEvents = kEvents[date] ?? [];
          final isDuplicate = existingEvents.any((work) => work.id == id);

          if (!isDuplicate) {
            kEvents[date] = [...existingEvents, work];
          }
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );

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
}
