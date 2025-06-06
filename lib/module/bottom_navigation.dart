import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/page/calendar.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/page/report_list_page.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/page/logout.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageProvider);

    String appBarTitle;
    Widget bodyWidget;
    switch (currentPage) {
      case PageType.Report:
        appBarTitle = "Report";
        bodyWidget = ReportListPage();
        break;
      case PageType.Logout:
        appBarTitle = "Logout";
        bodyWidget = LogoutPage();
        break;
      case PageType.Calendar:
        appBarTitle = "Calendar";
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
        selectedItemColor:  Colors.red[300],
        unselectedItemColor: Colors.grey,
        currentIndex: PageType.values.indexOf(currentPage),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_square),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
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
