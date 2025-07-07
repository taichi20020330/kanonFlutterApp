// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/data/riverpod_providers.dart';
import 'package:kanon_app/data/utils.dart';
import 'package:kanon_app/data/work_cateogory.dart';
import 'package:kanon_app/page/report_list_page.dart';
import 'package:kanon_app/repository/user_manager.dart';

class FormPage extends ConsumerStatefulWidget {
  FormPage({required this.mode, this.currentReport, this.workId, super.key});
  Report? currentReport;
  String? workId;
  final OpenFormPageMode mode;

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends ConsumerState<FormPage> {
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
  String commutingRoute = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Report? currentReport;
  String? workId;
  late OpenFormPageMode mode;
  List<WorkCategory> categories = [];
  String? selectedSubCategory;
  WorkCategory? selectedParentCategory;

  final TextEditingController userController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  void initState() {
    super.initState();
    mode = widget.mode;
    _routeController.addListener(() {
      setState(() {
        commutingRoute = _routeController.text;
      });
    });
    if (mode == OpenFormPageMode.edit) {
      currentReport = widget.currentReport;
      id = currentReport?.id;
      date = currentReport!.date;
      startTime = currentReport!.startTime;
      endTime = currentReport!.endTime;
      fee = currentReport!.fee!;
      description = currentReport!.description!;
      _routeController.text = currentReport!.commutingRoute!;
      selectedUser = UserManager().getUserName(currentReport!.user);
      
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result =
        await ref.read(reportListProvider.notifier).fetchCategories();
    setState(() {
      categories = result;

    if (mode == OpenFormPageMode.edit && currentReport != null) {
      final reportCatId = currentReport!.workCategory?['categoryId'];
      final reportSubName = currentReport!.workCategory?['childName'];

      selectedParentCategory =
          categories.firstWhere((cat) => cat.id == reportCatId);

      if (selectedParentCategory != null &&
          selectedParentCategory!.sub.contains(reportSubName)) {
        selectedSubCategory = reportSubName;
      }
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仕事の記録'),
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Container(
          color: Colors.grey[100],
          child: Form(
            key: _formKey,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                              TimeSelectField(),
                              UserLabelButton(
                                userName: selectedUser,
                                userController: userController,
                                onSelected: (newName) {
                                  setState(() {
                                    selectedUser = newName;
                                  });
                                },
                              ),
                              CommutingTextField(),
                              DescriptionTextField(),
                              WorkCategoryDropdowns(),
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
        ElevatedButton(
          onPressed: () => _selectTime(context, timeLabel),
          child: Text(
            (mode == TimeSelectButtonMode.startTimeMode) ? '開始時間' : '終了時間',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 254, 237, 237),
            foregroundColor: Colors.black, // 文字色
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text((selectTime != null)
            ? "${selectTime.hour}時${selectTime.minute}分"
            : ""),
      ],
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

  Widget CommutingTextField() {
    return Row(
      children: [
        RootTextField(),
        const SizedBox(width: 12),
        FeeTextField(),
      ],
    );
  }

  Widget FeeTextField() {
    final TextEditingController _feeController = TextEditingController(
      text: fee.toString(),
    );

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            controller: _feeController,
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
          padding: EdgeInsets.only(left: 4),
          child: Text('円', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget TimeSelectField() {
    return Row(
      children: [
        Column(
          children: [
            TimeSelectButton(context, TimeSelectButtonMode.startTimeMode),
            const SizedBox(
              height: 10,
            ),
            TimeSelectButton(context, TimeSelectButtonMode.endTimeMode),
          ],
        ),
        const SizedBox(width: 40),
        BreakTimeTextField(),
      ],
    );
  }

  Widget BreakTimeTextField() {
    final TextEditingController _breakTimeController = TextEditingController(
      text: breakTime.toString(),
    );

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: TextField(
            controller: _breakTimeController,
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
          padding: EdgeInsets.only(left: 4),
          child: Text('分', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  RootTextField() {
    return SizedBox(
      width: 180,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14),
              controller: _routeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '通勤経路',
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  _routeController.text += "→";
                },
                icon: const Icon(Icons.arrow_forward, size: 18),
                padding: EdgeInsets.all(1), // ← パディングをゼロにする
                constraints: BoxConstraints(), // ← 最小限サイズに抑える
              ),
              IconButton(
                onPressed: () {
                  _routeController.text += "↔︎";
                },
                icon: const Icon(Icons.compare_arrows, size: 18),
                padding: EdgeInsets.all(1), // ← パディングをゼロにする
                constraints: BoxConstraints(), // ← 最小限サイズに抑える
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget DescriptionTextField() {
    return SizedBox(
      width: 400,
      child: TextField(
        style: const TextStyle(fontSize: 14), // ← フォントサイズを小さく
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          labelText: '備考',
        ),
        onChanged: (value) {
          description = value;
        },
        maxLines: 2,
      ),
    );
  }

  Widget WorkCategoryDropdowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<WorkCategory>(
          hint: Text('カテゴリーを選択'),
          value: selectedParentCategory,
          items: categories.map((cat) {
            return DropdownMenuItem<WorkCategory>(
              value: cat,
              child: Text(cat.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedParentCategory = value;
              selectedSubCategory = null;
            });
          },
        ),
        if (selectedParentCategory != null &&
            selectedParentCategory!.sub.isNotEmpty)
          DropdownButton<String>(
            hint: Text('サブカテゴリーを選択'),
            value: selectedSubCategory,
            items: selectedParentCategory!.sub.map((sub) {
              return DropdownMenuItem<String>(
                value: sub,
                child: Text(sub),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubCategory = value!;
              });
            },
          ),
      ],
    );
  }

  _comfirmForm(BuildContext context) async {
  if (selectedUser.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('利用者を選択してください')),
    );
    return; 
  }

  if (selectedParentCategory == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('カテゴリーを選択してください')),
    );
    return;
  }

  if (!isCorrectTime(startTime!, endTime!)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('開始時間は終了時間より前に設定してください')),
    );
    return;
  }

  if (_formKey.currentState!.validate()) {
    addReportToFirebase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('登録しました')),
    );
    Navigator.pop(context);
  }
}

  void addReportToFirebase() {
    final auth = FirebaseAuth.instance;
    final helperId = auth.currentUser?.uid.toString() ?? '';
    final notifier = ref.read(reportListProvider.notifier);

    final report = Report(
        id: '',
        date: date,
        startTime: startTime!,
        endTime: endTime!,
        roundUpEndTime: roundTimeToNearest15Minutes(endTime!),
        fee: fee,
        description: description,
        user: UserManager().getUserId(selectedUser),
        helperId: helperId,
        deleteFlag: false,
        breakTime: breakTime,
        commutingRoute: commutingRoute,
        workCategory: {
          'categoryId': selectedParentCategory?.id ?? '',
          'categoryName': selectedParentCategory?.name ?? '',
          'childName': selectedSubCategory ?? '',
        });
    if (mode == OpenFormPageMode.edit) {
      notifier.updateReport(report.copyWith(id: currentReport!.id));
    } else {
      notifier.addReport(report);
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
    if (picked != null) {
      setState(() {
        final newTime = DateTime(
          startTime!.year,
          startTime!.month,
          startTime!.day,
          picked.hour,
          picked.minute,
        );
        if (timeLabel == TimeLabel.startTime) {
          startTime = newTime;
        } else {
          endTime = newTime;
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
        ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 254, 237, 237),
            foregroundColor: Colors.black, // 文字色
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          DateFormat('yyyy年MM月dd日').format(widget.date),
        ),
      ],
    );
  }
}

class UserLabelButton extends ConsumerWidget {
  final String userName;
  final TextEditingController userController;
  final Function(String) onSelected;

  const UserLabelButton({
    super.key,
    required this.userName,
    required this.userController,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteUsers = ref.watch(favoriteUserListProvider);

    return DropdownMenu<String>(
      initialSelection: userName,
      controller: userController,
      requestFocusOnTap: true,
      label: const Text('利用者'),
      onSelected: (String? newUserName) {
        if (newUserName != null) {
          onSelected(newUserName);
        }
      },
      dropdownMenuEntries: favoriteUsers.map<DropdownMenuEntry<String>>((user) {
        return DropdownMenuEntry<String>(
          value: user.name,
          label: user.name,
        );
      }).toList(),
    );
  }
}
