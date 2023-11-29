// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/report.dart';
import 'package:kanon_app/report_model.dart';
import 'package:riverpod/riverpod.dart';



class FormWidgetsDemo extends ConsumerStatefulWidget {
  const FormWidgetsDemo({super.key});

  @override
  FormWidgetsDemoState createState() => FormWidgetsDemoState();
}

class FormWidgetsDemoState extends ConsumerState<FormWidgetsDemo> {
  final TextEditingController userController = TextEditingController();

  UserLabel selectedUser = UserLabel.user0;
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  int fee = 0;
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  TimeOfDay? startTime = TimeOfDay.now();
  TimeOfDay? endTime = TimeOfDay.now();
  ReportModel reportModel = ReportModel();

  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(reportListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form widgets'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        _FormDatePicker(
                          date: date,
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () =>
                                    _selectTime(context, TimeLabel.startTime),
                                child: const Text(
                                  '開始時間',
                                )),
                            Text((startTime != null)
                                ? "${startTime?.hour}時${startTime?.minute}分"
                                : ""),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () =>
                                    _selectTime(context, TimeLabel.endTime),
                                child: const Text(
                                  '終了時間',
                                )),
                            Text((endTime != null)
                                ? "${endTime?.hour}時${endTime?.minute}分"
                                : ""),
                          ],
                        ),
                        DropdownMenu<UserLabel>(
                          initialSelection: UserLabel.user0,
                          controller: userController,
                          // requestFocusOnTap is enabled/disabled by platforms when it is null.
                          // On mobile platforms, this is false by default. Setting this to true will
                          // trigger focus request on the text field and virtual keyboard will appear
                          // afterward. On desktop platforms however, this defaults to true.
                          requestFocusOnTap: true,
                          label: const Text('利用者'),
                          onSelected: (UserLabel? user) {
                            setState(() {
                              selectedUser = user!;
                            });
                          },
                          dropdownMenuEntries: UserLabel.values
                              .map<DropdownMenuEntry<UserLabel>>(
                                  (UserLabel color) {
                            return DropdownMenuEntry<UserLabel>(
                              value: color,
                              label: color.label,
                            
                            );
                          }).toList(),
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: '340',
                            labelText: '交通費',
                          ),
                          onChanged: (value) {
                            fee = int.parse(value);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: 'Enter a description...',
                            labelText: '備考',
                          ),
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 5,
                        ),
                        ElevatedButton(
                            onPressed: () => _comfirmForm(context),
                            child: Text('登録',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: const StadiumBorder(),
                            ))
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _comfirmForm(BuildContext context) {
    ref.read(reportListProvider.notifier).addReport(
        date, startTime!, endTime!, fee, description, selectedUser!.index);

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
    Navigator.pop(context);
  }


  Future<void> _selectTime(BuildContext context, TimeLabel timeLabel) async {
    if (timeLabel == TimeLabel.startTime) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != startTime) {
        setState(() {
          startTime = picked;
        });
      }
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != endTime) {
        setState(() {
          endTime = picked;
        });
      }
    }
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          child: const Text('日付'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }
            widget.onChanged(newDate);
          },
        ),
        Text(
          widget.date.toString(),
        ),
      ],
    );
  }
}
