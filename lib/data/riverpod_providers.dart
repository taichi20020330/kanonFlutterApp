import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanon_app/%20model/favorite_user_list_notifier.dart';
import 'package:kanon_app/data/enum.dart';

import 'user.dart' as data;


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

final favoriteUserListProvider =
  StateNotifierProvider<FavoriteUserListNotifier, List<data.User>>(
  (ref) => FavoriteUserListNotifier(),
);