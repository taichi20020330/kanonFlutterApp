// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/repository/user_manager.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/data/report.dart';

class FormPage extends ConsumerStatefulWidget {
  FormPage({required this.mode, this.currentReport, this.workId, super.key});
  Report? currentReport;
  String? workId;
  final OpenFormPageMode mode;

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends ConsumerState<FormPage> {
  final TextEditingController userController = TextEditingController();

  String selectedUser = "";
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String commuingRoute = '';
  String? id;
  int fee = 0;
  int breakTime = 0;
  String departure = '';
  String destination = '';
  bool isRoundTrip = false;
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Report? currentReport;
  String? workId;
  late OpenFormPageMode mode;
  late List<String> userNames;

  void initState() {
    super.initState();
    mode = widget.mode;

    if (mode == OpenFormPageMode.edit) {
      currentReport = widget.currentReport;
      id = currentReport?.id;
      date = currentReport!.date;
      startTime = currentReport!.startTime;
      endTime = currentReport!.endTime;
      fee = currentReport!.fee!;
      description = currentReport!.description!;
      selectedUser = UserManager().getUserName(currentReport!.user);
    } else if (mode == OpenFormPageMode.workTap) {
      currentReport = widget.currentReport;
      id = currentReport?.id;
      date = currentReport!.date;
      startTime = currentReport!.startTime;
      endTime = currentReport!.endTime;
      fee = currentReport!.fee!;
      description = currentReport!.description!;
      selectedUser = UserManager().getUserName(currentReport!.user);
      workId = widget.workId;
    }

    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(reportListProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Future(() {
    //   final userListModel = context.read<UserListModel>();
    //   userListModel.getUsers();
    // });

    return Scaffold(
      appBar: AppBar(
        title: const Text('仕事の記録'),
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Form(
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
                          TimeSelectButton(
                              context, TimeSelectButtonMode.startTimeMode),
                          TimeSelectButton(
                              context, TimeSelectButtonMode.endTimeMode),
                          BreakTimeTextField(),
                          UserLabelButton(selectedUser),
                          FeeTextField(),
                          RootTextField(),
                          DescriptionTextField(),
                          RegisterButton(),
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
      ),
    );
  }

  Widget TimeSelectButton(BuildContext context, TimeSelectButtonMode mode) {
    DateTime? selectTime;
    TimeLabel timeLabel;
    if (mode == TimeSelectButtonMode.startTimeMode) {
      selectTime = startTime;
      timeLabel = TimeLabel.startTime;
    } else {
      selectTime = endTime;
      timeLabel = TimeLabel.endTime;
    }

    return Row(
      children: [
        TextButton(
            onPressed: () => _selectTime(context, timeLabel),
            child: Text(
              (mode == TimeSelectButtonMode.startTimeMode) ? '開始時間' : '終了時間',
            )),
        Text((selectTime != null)
            ? "${selectTime.hour}時${selectTime.minute}分"
            : ""),
      ],
    );
  }

  UserLabelButton(String userName) {
        return DropdownMenu<String>(
        initialSelection: userName,
        controller: userController,
        requestFocusOnTap: true,
        label: const Text('利用者'),
        onSelected: (String? newUserName) {
          setState(() {
            selectedUser = newUserName!;
          });
        },
        dropdownMenuEntries: UserManager().getAllUserName().map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      );


  }

  Widget RegisterButton() {
    return ElevatedButton(
        onPressed: () => _comfirmForm(context),
        child: Text('登録', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const StadiumBorder(),
        ));
  }

  Widget FeeTextField() {
    final TextEditingController controller = TextEditingController(
      text: fee.toString(),
    );

    return Row(
      children: [
        SizedBox(
              width: 80,
              child: TextField(
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: '交通手当',
                ),
                onChanged: (value) {
                  fee = int.parse(value);
                },
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 10),
              child:  Text('円' , style: TextStyle(fontSize: 12)),
            ),
      ],
    );

  }

  Widget BreakTimeTextField() {
    final TextEditingController controller = TextEditingController(
      text: breakTime.toString(),
    );

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: '休憩時間',
                ),
                onChanged: (value) {
                  breakTime = int.parse(value);
                },
              ),
        ),
            const Padding(
              padding:  EdgeInsets.only(left: 10),
              child:  Text('分' , style: TextStyle(fontSize: 12)),
            ),
      ],
    );

    
  }

  Widget RootTextField() {
    return TextFormField(
      initialValue: commuingRoute,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        hintText: '石橋から池田、往復',
        labelText: '通勤経路等',
      ),
      onChanged: (value) {
        commuingRoute = value;
      },
    );
  }


  Widget DescriptionTextField() {
    return TextFormField(
      initialValue: description,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: '備考',
      ),
      onChanged: (value) {
        description = value;
      },
      maxLines: 3,
    );
  }

  _comfirmForm(BuildContext context) async {
    // isCorrectTimeがfalseの場合はエラーを表示
    if (!isCorrectTime(startTime!, endTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('開始時間は終了時間より前に設定してください')),
      );
      print(startTime);
      print(endTime);
    } else {
      if (_formKey.currentState!.validate()) {
        addReportToFirebase();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登録しました')),
        );
      }
      Navigator.pop(context);
    }
  }

  void addReportToFirebase() {
    final auth = FirebaseAuth.instance;
    final helperId = auth.currentUser?.uid.toString() ?? '';

    //idが存在する場合は編集
    if (mode == OpenFormPageMode.edit) {
      ref.read(reportListProvider.notifier).updateReport(
          currentReport!.id,
          date,
          startTime!,
          endTime!,
          fee,
          description,
          UserManager().getUserId(selectedUser),
          helperId);
    } else if (mode == OpenFormPageMode.add) {
      ref.read(reportListProvider.notifier).addReport(date, startTime!,
          endTime!, fee, description, UserManager().getUserId(selectedUser), helperId);
    } else if (mode == OpenFormPageMode.workTap && workId != null) {
      ref.read(reportListProvider.notifier).addRelatedReport(date, startTime!,
          endTime!, fee, description, UserManager().getUserId(selectedUser), helperId, workId!);

    }
  }

  Future<void> _selectTime(BuildContext context, TimeLabel timeLabel) async {
    DateTime selectTime;

    if (timeLabel == TimeLabel.startTime) {
      selectTime = startTime;
    } else {
      selectTime = endTime;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (selectTime != null)
          ? TimeOfDay.fromDateTime(selectTime)
          : TimeOfDay.now(),
      // initialTime: TimeOfDay.fromDateTime(startTime),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectTime) {
      setState(() {
        if (timeLabel == TimeLabel.startTime) {
          
          startTime = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
        } else {
          endTime = DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
        }
      });
    }
  }
}

bool isCorrectTime(DateTime startTime, DateTime endTime) {
  bool isCorrectTime = true;
  if (startTime.isAfter(endTime)) {
    isCorrectTime = false;
  }
  if (startTime == endTime) {
    isCorrectTime = false;
  }
  return isCorrectTime;
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
          DateFormat('yyyy年MM月dd日').format(widget.date),
        ),
      ],
    );
  }
}


  // RootTextField() {
  //   final TextEditingController departure_controller = TextEditingController();
  //   final TextEditingController destination_controller =
  //       TextEditingController();

  //   const List<String> trip_list = <String>['片道', '往復'];
  //   String dropdownValue = trip_list.first;

  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 80,
  //         child: TextField(
  //           controller: departure_controller,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(),
  //             labelText: '出発地',
  //           ),
  //           onChanged: (value) {
  //             departure = value;
  //           },
  //         ),
  //       ),
  //       const SizedBox(width: 20), // ここで間隔を追加
  //       SizedBox(
  //           width: 120,
  //           child: DropdownMenu<String>(
  //             initialSelection: trip_list.first,
  //             onSelected: (String? value) {
  //               // This is called when the user selects an item.
  //               setState(() {
  //                 dropdownValue = value!;
  //               });
  //             },
  //             dropdownMenuEntries:
  //                 trip_list.map<DropdownMenuEntry<String>>((String value) {
  //               return DropdownMenuEntry<String>(value: value, label: value);
  //             }).toList(),
  //           )),
  //       const SizedBox(width: 20), // ここで間隔を追加
  //       SizedBox(
  //         width: 80,
  //         child: TextField(
  //           controller: destination_controller,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(),
  //             labelText: '到着地',
  //           ),
  //           onChanged: (value) {
  //             destination = value;
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }