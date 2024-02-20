import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/%20model/work_model.dart';
import 'package:kanon_app/data/provider.dart';
import 'package:kanon_app/data/work.dart';

class ScheduleListPage extends HookConsumerWidget {
  const ScheduleListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScheduleList(
      context,
      ref,
    );
  }

  ScheduleList(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Work>> works = ref.watch(worksProvider);
    return Center(
      child: works.when(
        data: (worksList) {
          if (worksList.isEmpty) {
            return const Text('No works available.');
          }

          return ListView.builder(
            itemCount: worksList.length,
            itemBuilder: (context, index) {
              final work = worksList[index];
              return ListTile(
                title: Text(work.id),
                subtitle: Text(work.date.toString()),
                // 他のアクティビティプロパティにアクセスするには、ここに追加
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
