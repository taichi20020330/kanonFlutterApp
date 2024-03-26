import 'package:kanon_app/data/enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
