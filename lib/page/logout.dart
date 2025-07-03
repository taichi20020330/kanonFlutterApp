import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/%20model/favorite_user_list_notifier.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/riverpod_providers.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/data/user.dart' as data;
import 'package:kanon_app/page/login.dart';
import 'package:kanon_app/page/report_list_page.dart';



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
        title: const Text('設定'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
LogoutButton(),
      MyListButton(),

        ],
      ),
      Expanded(child: AllUserListView()),
      const SizedBox(height: 16),
    ],
        ),
      ),
    ));
  }

  

  Widget LogoutButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            try {
              // ログアウト処理
              await FirebaseAuth.instance.signOut();
              ref.read(pageProvider.notifier).changePage(PageType.Report);
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
    );
  }

  Widget BackButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            ref.read(pageProvider.notifier).changePage(PageType.Report);
          },
          child: Text('戻る')),
    );
  }

  Widget MyListButton() {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return FavoriteUserListPopup();
              },
            );
          },
          child: Text('自分のリストを確認')),
    );
  }

  
}

class FavoriteUserListPopup extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteUsers = ref.watch(favoriteUserListProvider);

    return ListView.builder(
      itemCount: favoriteUsers.length,
      itemBuilder: (context, index) {
        final user = favoriteUsers[index];
        return ListTile(
          title: Text(user.name),
          trailing: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              ref.read(favoriteUserListProvider.notifier).removeUser(user);
            },
          ),
        );
      },
    );
  }
}

class AllUserListView extends ConsumerWidget {
  const AllUserListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(userListProvider);
    final favoriteUsers = ref.watch(favoriteUserListProvider);

    // お気に入りに含まれていないユーザーだけ
    final filteredUsers = allUsers.where(
      (user) => !favoriteUsers.any((fav) => fav.id == user.id),
    ).toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16.0), // 🔑 上に余白を追加
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Column(
            children: [
              ListTile(
                title: Text(user.name),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    ref.read(favoriteUserListProvider.notifier).addUser(user);
                  },
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[300], // 🔑 もっと薄いグレー
              ),
            ],
          );
        },
      ),
    );
  }
}
