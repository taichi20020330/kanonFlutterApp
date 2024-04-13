// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kanon_app/%20model/work_model.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/work.dart';
import 'package:kanon_app/main.dart';
import 'package:kanon_app/data/report.dart';
import 'package:kanon_app/%20model/report_model.dart';

class TestPage extends ConsumerStatefulWidget {

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends ConsumerState<TestPage> {
  late WorkListNotifier workModel;
  late StreamProvider _streamProvider;


  void initState() {
    super.initState();
    // workModel = WorkListNotifier();
    // _streamProvider = StreamProvider<List<Work>>((ref) => 
    // workModel.getSnapshot().map((e) => 
    // e.docs.map((data) => 
    // _convert(data.data())).toList()
    // ));
    
  }

  Work _convert(Object? obj) {
    if(obj == null) {
      return Work(
        id: '',
        date: DateTime.now(),
        scheduledStartTime: 0,
        scheduledEndTime: 0,
        userId: 1,
        helperId: 1,
      );
    }

    var map = obj as Map<String, dynamic>;
    return Work.fromJson(map);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仕事の記録'),
      ),
      body: Consumer(
        builder:(context, ref, child) {
          final provider = ref.watch(_streamProvider);
                return provider.when(
                  error: (error, stack) => Text('Error'), 
                  loading: () => const CircularProgressIndicator(),
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data[index].id),
                          subtitle: Text(data[index].date.toString()),
                        );
                      },
                    );
                  }
                  );
                  
        }
        )
    );
  }

  
}

