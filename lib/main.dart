import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/module/bottom_navigation.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/provider.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/%20model/report_model.dart';
import 'package:kanon_app/page/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kanon_app/page/form.dart';
import 'firebase_options.dart';

final reportListProvider = ChangeNotifierProvider((ref) => ReportModel());
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
    // return const MaterialApp(
    //   localizationsDelegates: [
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],
    //   supportedLocales: [
    //     Locale('ja'),
    //   ],
    //   locale: Locale('ja'),
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   home: LoginPage(),
    // );
    return StreamBuilder(
      
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          // ログインしている場合の表示するウィジェット
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
            home: BottomNavigationPage(),
          );
        } else {
          // ログインしていない場合の表示するウィジェット
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
            home: LoginPage(),
          );
        }
      },
    );
  }
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
    switch (userNumber) {
      case 0:
        return '戸松さん';
      case 1:
        return '吉田さん';
      case 2:
        return '岡本さん';
      case 3:
        return '秋谷さん';
      case 4:
        return '前田さん';
      default:
        return '戸松さん';
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
            openFormPage(context, OpenFormPageMode.edit, report);
            break;
          case 'delete':
            ref.read(reportListProvider.notifier).removeReport(report);
            break;
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
