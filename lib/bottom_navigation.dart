import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/calender.dart';
import 'package:kanon_app/enum.dart';
import 'package:kanon_app/form.dart';
import 'package:kanon_app/home.dart';
import 'package:kanon_app/main.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageProvider);

    String appBarTitle;
    Widget bodyWidget;
    switch(currentPage) {
      case PageType.Report:
        appBarTitle = "Report";
        bodyWidget = Home();
        break;
      case PageType.Calender:
        appBarTitle = "Calender";
        bodyWidget = TableEventsExample();
        break;
      case PageType.Settings:
        appBarTitle = "Settings";
        bodyWidget = Container();
        break;
    }

    return Scaffold(
      body: bodyWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: PageType.values.indexOf(currentPage),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          final pageType = PageType.values[index];
          ref.read(pageProvider.notifier).changePage(pageType);
        },
      ),
    );
  }
}