
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kanon_app/%20model/work_notifier.dart';
import 'package:kanon_app/data/enum.dart';
import 'package:kanon_app/data/work.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;


class PageNotifier extends Notifier<PageType> {
  
  @override
  build() {
    return PageType.Report;  // 最初に表示するページを設定
  }

  // タブが切り替わった時に呼ばれる
  void changePage(PageType pageType) {
    state = pageType;
  }
}

