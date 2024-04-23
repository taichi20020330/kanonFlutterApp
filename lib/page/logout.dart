import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/page/login.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  String email = '';
  String password = '';
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログアウト'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('本当にログアウトしますか？')),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // ログアウト処理
                        await FirebaseAuth.instance.signOut();
                        ref
                            .read(pageProvider.notifier)
                            .changePage(PageType.Report);
                        // ログイン画面に遷移＋チャット画面を破棄
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }),
                        );
                      } catch (e) {
                        // ログインに失敗した場合
                        setState(() {
                          infoText = "ログアウトに失敗しました：${e.toString()}";
                        });
                      }
                    },
                    child: Text('ログアウト')),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(pageProvider.notifier)
                          .changePage(PageType.Report);
                    },
                    child: Text('戻る')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
