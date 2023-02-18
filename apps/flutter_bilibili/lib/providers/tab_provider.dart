import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bilibili/constants/tokens.dart';
import 'package:flutter_bilibili/models/tab_item.dart';

class TabProvider with ChangeNotifier {
  int _currentTabId = 0;

  TabItem get currentTab => tabList.singleWhere(
        (element) => element.id == _currentTabId,
        orElse: () =>
            tabList.singleWhere((element) => element.isDefault == true),
      );

  List<TabItem> tabList = [
    TabItem(id: 0, title: '直播'),
    TabItem(
      id: 1,
      title: '推荐',
      isDefault: true,
      refreshable: true,
    ),
    TabItem(id: 2, title: '热门'),
    TabItem(id: 3, title: '动画'),
    TabItem(id: 4, title: '影视'),
  ];

  void setCurrentTabId(int id) {
    _currentTabId = id;
  }
}
