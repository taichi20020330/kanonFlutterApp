// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/%20model/work_notifier.dart';
import 'package:kanon_app/customized_plugin/customization/calendar_builders.dart';
import 'package:kanon_app/customized_plugin/customization/calendar_style.dart';
import 'package:kanon_app/customized_plugin/shared/utils.dart';
import 'package:kanon_app/customized_plugin/table_calendar.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/data/work.dart';
import 'package:kanon_app/page/home.dart';
import '../data/utils.dart';

Map<DateTime, List<Work>> kEvents = {};
Map<DateTime, List<Work>> _kEventSource = {};

class TableEventsExample extends ConsumerStatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends ConsumerState<TableEventsExample> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final ValueNotifier<List<Work>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Work? _work;
  List<Work> currentWorkList = [];
  int helperId = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initializeData();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    helperId = getHelperId();
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

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

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
          child: const Icon(Icons.refresh),
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
      child: ValueListenableBuilder<List<Work>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          // _selectedEventsをscheduleStartTimeでソート
          value.sort(
              (a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final work = value[index];
              bool isAttached = work.reportId != "";
              print(work.id);
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
                  trailing: (isAttached)
                      ? const Icon(
                          Icons.content_copy,
                          // 薄い赤色
                        )
                      : const Icon(
                          Icons.error,
                          // 薄い赤色
                          color: Colors.redAccent,
                        ),
                  onTap: () {
                    // タップした時の処理
                    submitReportsFromCalendar(context, work);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget CalendarWidget() {
    bool yetSubmitted = true;
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
      
      calendarBuilders: CalendarBuilders<Work>(
      markerBuilder: (context, date, events) {
        // eventsのreportIdが
        yetSubmitted = false;
        for(final event in events){
          if(event.reportId != ""){
            yetSubmitted = true;
          }
        }
      },
    ),
    calendarStyle:  CalendarStyle(
        outsideDaysVisible: false,
        markerDecoration: BoxDecoration(
          color: (yetSubmitted == false) ? Colors.redAccent : const Color(0xFF263238),
          shape: BoxShape.circle,)
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
    if (kEvents[day] != null) {}
    return kEvents[day] ?? [];
  }

  List<Work> _getEventsForRange(DateTime start, DateTime end) {
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
    final dateOnly = DateTime(date.year, date.month, date.day);
    final existingEvents = _kEventSource[dateOnly] ?? [];
    final helperId = work.helperId;

    final isDuplicate =
        existingEvents.any((existingWork) => existingWork.id == id);
    final isSameUser = helperId == this.helperId;
    if (!isDuplicate && isSameUser) {
      _kEventSource[dateOnly] = [...existingEvents, work];
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

  // ユーザー情報を取得する関数
  int getHelperId() {
    int heplerId = 0;
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user!.uid;

        heplerId = helperIdMappingList[uid] ?? 0;
      }
    } catch (e) {
      print(e);
    }
    return heplerId;
  }

  void submitReportsFromCalendar(BuildContext context, Work work) {
    final report = convertReportFromWork(work);
    openFormPage(context, OpenFormPageMode.workTap, report, work.id);
  }

  Report convertReportFromWork(Work work) {
    final startTime =
        getDateTimeFromIntTime(work.date, work.scheduledStartTime);
    final endTime = getDateTimeFromIntTime(work.date, work.scheduledEndTime);

    return Report(
      id: work.id,
      date: work.date,
      startTime: startTime,
      endTime: endTime,
      roundUpEndTime: endTime,
      fee: 0,
      description: "",
      user: work.userId,
      deleteFlag: false,
    );
  }

  DateTime getDateTimeFromIntTime(DateTime date, int time) {
    int hours = time ~/ 100; // 時間を取得
    int minutes = time % 100; // 分を取得

    return DateTime(date.year, date.month, date.day, hours, minutes);
  }
}
