import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tbk_app/modle/conversation.dart';
import 'package:tbk_app/widgets/pull_load/PullLoadWidget.dart';

/**
 * 上下拉刷新列表的通用State
 */
mixin ListState<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T> {
  bool isShow = false;

  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final PullLoadWidgetControl pullLoadWidgetControl = new PullLoadWidgetControl();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  List<Conversation> mockConversation = [];
  List<Conversation> preConversation = [
    const Conversation(avatar: '', title: '', createAt: '', describtion: ''),
    const Conversation(
        type: '官方',
        avatar: 'static/images/cainiaoyizhan.png',
        title: '菜鸟驿站',
        titleColor: 0xFF7f3410,
        createAt: '09:28',
        describtion: '手慢无！抢最高2019元大包',
        unReadMsgCount: 2),
    const Conversation(
        type: '官方',
        avatar: 'static/images/taobaotoutiao.png',
        title: '淘宝头条',
        titleColor: 0xFF7f3410,
        createAt: '12:30',
        describtion: '这栋老宅被加价5000多万，还说买家赚钱了？',
        displayDot: false,
        unReadMsgCount: 8),
    const Conversation(
      type: '官方',
      avatar: 'static/images/88members.png',
      title: '淘气值',
      titleColor: 0xFF7f3410,
      createAt: '14:01',
      describtion: '88VIP 独家包场免费看《复仇4》',
      unReadMsgCount: 10,
    ),
    const Conversation(
      type: '品牌',
      avatar: 'static/images/apple_home.png',
      title: '苹果家园',
      titleColor: 0xFF7f3410,
      createAt: '昨天',
      describtion: '😂😁🙏☺️💪👍亲，您看中的咨询的产品还没下单，请及时下单付款哟，以便快马加鞭的帮您送达呢 (*^▽^*)',
      unReadMsgCount: 5,
    ),
  ];


  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  @protected
  resolveRefreshResult(res) {
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
  }

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await requestRefresh();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    return null;
  }

  @protected
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var res = await requestLoadMore();
    if (res != null && res.result) {
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @protected
  resolveDataResult(res) {
    if (isShow) {
      setState(() {
        pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && res.data.length == 20);
      });
    }
  }

  @protected
  clearData() {
    if (isShow) {
      setState(() {
        pullLoadWidgetControl.dataList.clear();
      });
    }
  }

  ///下拉刷新数据
  @protected
  requestRefresh() async {}

  ///上拉更多请求数据
  @protected
  requestLoadMore() async {}

  ///是否需要第一次进入自动刷新
  @protected
  bool get isRefreshFirst;

  ///是否需要头部
  @protected
  bool get needHeader => false;

  ///是否需要保持
  @override
  bool get wantKeepAlive => true;

  List get getDataList => dataList;

  @override
  void initState() {
    isShow = true;
    super.initState();
    pullLoadWidgetControl.needHeader = needHeader;
    pullLoadWidgetControl.dataList = getDataList;
    if (pullLoadWidgetControl.dataList.length == 0 && isRefreshFirst) {
      showRefreshLoading();
    }
  }

  @override
  void dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }
}
