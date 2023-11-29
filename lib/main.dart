import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/form.dart';
import 'package:kanon_app/report.dart';
import 'package:kanon_app/report_model.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';



final reportListProvider =
    NotifierProvider<ReportModel, List<Report>>(ReportModel.new);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              for (var i = 0; i < reports.length; i++) ...[
                if (i > 0) const Divider(height: 0),
                ProviderScope(
                  overrides: [
                    _currentReport.overrideWithValue(reports[i]),
                  ],
                  child: const ReportItem(),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormPage(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _openFormPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FormWidgetsDemo(),
      ),
    );
  }
}

final _currentReport = Provider<Report>((ref) => throw UnimplementedError());

class ReportItem extends HookConsumerWidget {
  const ReportItem({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(_currentReport);

    return  Material(
      child: ListTile(
      title: Text(
        report.date.toString() + report.startTime.format(context)
      ),
    ),
    );
  }
}
