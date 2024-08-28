import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/data/enum.dart';


class PageNotifier extends Notifier<PageType> {
  @override
  build() {
    return PageType.Report; // 最初に表示するページを設定
  }

  // タブが切り替わった時に呼ばれる
  void changePage(PageType pageType) {
    state = pageType;
  }
}
