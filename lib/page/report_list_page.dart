import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/utils.dart';
import 'package:kanon_app/page/form.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/repository/user_manager.dart';

class ReportListPage extends ConsumerStatefulWidget {
  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends ConsumerState<ReportListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<Report>> groupedReports = {};
  List<Report> sortedReports = [];

  @override
  void initState() {
    super.initState();
    UserManager().initializeUsers().then((_) {
      setState(() {}); // 必要に応じて状態を更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref.watch(reportListProvider).fetchReports(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データ取得中の表示など、ローディング表示を追加することができます
            return const CircularProgressIndicator(); // 例: ローディング中のインジケーター
          } else if (snapshot.hasError) {
            // エラーが発生した場合の表示
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.hasData) {
              final reports = snapshot.data?.docs
                      .map((doc) => Report(
                          id: doc.id,
                          startTime: doc['startTime'].toDate(),
                          endTime: doc['endTime'].toDate(),
                          roundUpEndTime: doc['roundUpEndTime'].toDate(),
                          fee: doc['fee'],
                          user: doc['user'],
                          helperId: doc['helperId'],
                          description: doc['description'],
                          date: doc['date'].toDate(),
                          deleteFlag: doc['deleteFlag']))
                      .toList() ??
                  [];

                sortedReports = reports
                ..sort((Report a, Report b) => a.date.compareTo(b.date));
              groupedReports = groupReportsByMonth(sortedReports);
              int tabInitialIndex = getTabInitialIndex(groupedReports);
              _tabController = TabController(
                length: groupedReports.keys.length,
                vsync: this,
                initialIndex: tabInitialIndex,
              );

              return DefaultTabController(
                length: groupedReports.keys.length,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('出勤簿リスト'),
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: groupedReports.keys
                          .map((String month) => Tab(
                                text: month,
                              ))
                          .toList(),
                    ),
                  ),
                  body: ReportListBottomTabBar(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        openFormPage(context, OpenFormPageMode.add, null, null),
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator(); // 例: ローディング中のインジケーター
            }
          }
        });
  }

  Widget ReportListBottomTabBar() {
    return TabBarView(
      controller: _tabController,
      children: groupedReports.entries.map((entry) {
        List<Report> sortedReports = entry.value
            .where((report) => !report.deleteFlag)
            .toList()
          ..sort((a, b) {
            int dateComparison = a.date.compareTo(b.date);
            if (dateComparison != 0) {
              return dateComparison;
            } else {
              return a.startTime.compareTo(b.startTime);
            }
          });
        Duration totalWorkTime = calculateTotalWorkTime(sortedReports);
        double monthlySalary = calculateMonthlySalary(totalWorkTime);

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            WorkTimeText(totalWorkTime),
            SalaryText(monthlySalary),
            for (var report in sortedReports) ...[
              if (sortedReports.contains(report))
                ProviderScope(
                  overrides: [
                    _currentReport.overrideWithValue(report),
                  ],
                  child: const ReportItem(),
                ),
            ],
          ],
        );
      }).toList(),
    );
  }

  Widget WorkTimeText(Duration totalWorkTime) {
  return Text(
    '合計勤務時間: ${totalWorkTime.inHours} 時間 ${totalWorkTime.inMinutes.remainder(60)} 分',
    style: const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    ),
  );
}

Widget SalaryText(double monthlySalary) {
  return Text(
    '給与: ${monthlySalary.toInt()}円',
    style: const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    ),
  );
}
}



Map<String, List<Report>> groupReportsByMonth(List<Report> reports) {
  Map<String, List<Report>> groupedReports = {};

  for (var report in reports) {
    String formattedMonth = DateFormat('yyyy/MM').format(report.date);
    if (!groupedReports.containsKey(formattedMonth)) {
      groupedReports[formattedMonth] = [];
    }
    groupedReports[formattedMonth]!.add(report);
  }

  return groupedReports;
}

int getTabInitialIndex(Map<String, List<Report>> groupedReports) {
  DateTime now = DateTime.now();
  String formattedNow = DateFormat('yyyy/MM').format(now);
  int tabInitialIndex = 0;
  if (groupedReports.containsKey(formattedNow)) {
    tabInitialIndex = groupedReports.keys.toList().indexOf(formattedNow);
  }
  return tabInitialIndex;
}

final _currentReport = Provider<Report>((ref) => throw UnimplementedError());

class ReportItem extends HookConsumerWidget {
  const ReportItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(_currentReport);
    String formattedDate = DateFormat('yyyy年MM月dd日').format(report.date);

    return Material(
      child: Card(
        child: ListTile(
          title: Text(
            selectUser(report.user),
          ),
          subtitle: Text(
              '$formattedDate ${formatTime(report.startTime)} ~ ${formatTime(report.endTime)}'),
          trailing: const CardMenuTrailing(),
        ),
      ),
    );
  }

  String selectUser(int userNumber) {
    if (userNumber >= 0 && userNumber <= 30) {
      return UserManager().getUserName(userNumber);
    } else {
      return "papapapa"; // デフォルトの値
    }
  }

  String formatTime(DateTime time) {
    // intlパッケージを使用して24時間形式でフォーマット
    final formattedTime =
        DateFormat.Hm().format(DateTime(2023, 1, 1, time.hour, time.minute));
    return formattedTime;
  }
}

class CardMenuTrailing extends HookConsumerWidget {
  const CardMenuTrailing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(_currentReport);
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'edit',
            child: Text('編集'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('削除'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'edit':
            openFormPage(context, OpenFormPageMode.edit, report, null);
            break;
          case 'delete':
            ref.read(reportListProvider.notifier).removeReport(report);
            break;
        }
      },
    );
  }
}

openFormPage(BuildContext context, OpenFormPageMode mode, Report? report,
    String? workId) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FormPage(
        mode: mode,
        currentReport: report,
        workId: workId,
      ),
    ),
  );
}
