import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kanon_app/bottom_navigation.dart';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/provider.dart';
import 'package:kanon_app/report.dart';
import 'package:kanon_app/report_model.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

final reportListProvider =
    NotifierProvider<ReportModel, List<Report>>(ReportModel.new);
final pageProvider = NotifierProvider<PageNotifier, PageType>(PageNotifier.new);


void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      // routerConfig: _router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja'),
      ],
      locale: Locale('ja'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: BottomNavigationPage(),
    );
  }
}
