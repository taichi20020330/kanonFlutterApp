// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/provider.dart';
import 'package:kanon_app/work.dart';
import 'package:table_calendar/table_calendar.dart';

import 'utils.dart';

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

  late final ValueNotifier<List<Event>> _selectedEvents;
  List<Map<String, dynamic>> scheduleList = [];
  List<Work> previousWorks = [];

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
        if (!listEquals(worksList, previousWorks)) {
          for (var work in worksList) {
            String title = '${convertUserIdToUserName(work.userId)} '
                ' ${convertToTimeFormat(work.scheduledStartTime)}';
            scheduleList.add({
              'datetime': work.date,
              'title': title,
            });
          }
        }
        previousWorks = worksList;
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
    _addEventFromList(scheduleList);

    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
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
            child: ValueListenableBuilder<List<Event>>(
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

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
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

  void _addEventFromList(List<Map<String, dynamic>> scheduleList) {
    for (var schedule in scheduleList) {
      final date = schedule['datetime'] as DateTime?;
      final title = schedule['title'] as String?;

      if (date != null && title != null) {
        // Check if the event with the same date and title already exists
        final existingEvents = kEvents[date] ?? [];
        final isDuplicate = existingEvents.any((event) => event.title == title);

        if (!isDuplicate) {
          // If not a duplicate, add the event
          final event = Event(title);
          kEvents[date] = [...existingEvents, event];
        }
      }
    }
    // Update selected events
    // _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  String convertUserIdToUserName(int id) {
    // simpleUserNameListのid番目の要素を返す
    return simpleUserNameList[id];
  }

  String convertToTimeFormat(int input) {
    // 桁数が足りない場合はエラーとしてnullを返す
    if (input < 100 || input > 2359) {
      return "";
    }

    // 入力された数字から時と分を取得
    int hour = input ~/ 100;
    int minute = input % 100;

    // 時と分が適切な範囲か確認
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return "";
    }

    // 時間と分をフォーマットして返す
    return '${hour.toString()}:${minute.toString().padLeft(2, '0')}';
  }
}
