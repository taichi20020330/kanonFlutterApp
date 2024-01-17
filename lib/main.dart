import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/bottom_navigation.dart';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/home.dart';
import 'package:kanon_app/provider.dart';
import 'package:kanon_app/report.dart';
import 'package:kanon_app/form.dart';
import 'package:kanon_app/report_model.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



final reportListProvider =
    // NotifierProvider<ReportModel, List<Report>>(ReportModel.new);
    ChangeNotifierProvider((ref) => ReportModel());
  final pageProvider = NotifierProvider<PageNotifier, PageType>(PageNotifier.new);


void main() async {

  //追記するコード
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return const MaterialApp(
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
      home: Home(),
    );
  }
}