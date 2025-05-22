import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/data/riverpod_providers.dart';
import 'package:kanon_app/module/bottom_navigation.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/page/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kanon_app/page/form.dart';
import 'package:kanon_app/page/report_list_page.dart';
import 'firebase_options.dart';

// final reportListProvider = ChangeNotifierProvider((ref) => ReportModel());
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
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          // ログインしている場合の表示するウィジェット
          return  MaterialApp(
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
            theme: ThemeData(
              colorScheme:  const ColorScheme(
                primary: Color(0xFFEF9A9A),  // 薄いピンク
                secondary: Color(0xFFE57373),  // 少し濃いピンク
                surface: Colors.white,
                error: Colors.red,
                onPrimary: Colors.black,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              textTheme: Theme.of(context).textTheme.apply(
              fontSizeDelta: -1.0,
            ),
            ),
            home: ReportListPage(),
          );
        } else {
          // ログインしていない場合の表示するウィジェット
          return  MaterialApp(
            localizationsDelegates:  const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ja'),
            ],
            locale: const Locale('ja'),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme:  const ColorScheme(
                primary: Color(0xFFEF9A9A),  // 薄いピンク
                secondary: Color(0xFFE57373),  // 少し濃いピンク
                surface: Colors.white,
                error: Colors.red,
                onPrimary: Colors.black,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              textTheme: Theme.of(context).textTheme.apply(
              fontSizeDelta: -1.0,
            ),
            ),
            

            home: const LoginPage(),
          );
        }
      },
    );
  }
}


openFormPage(BuildContext context, OpenFormPageMode mode, Report? report) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FormPage(
        mode: mode,
        currentReport: report,
      ),
    ),
  );
}
