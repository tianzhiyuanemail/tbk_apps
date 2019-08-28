import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tbk_app/res/colors.dart';

class MyEasyRefresh extends StatefulWidget {
  EasyRefreshController easyRefreshController;

  Function onRefresh;
  Function onLoad;
  Widget child;

  MyEasyRefresh(
      {Key key,
      this.easyRefreshController,
      this.onRefresh,
      this.onLoad,
      this.child});

  @override
  _MyEasyRefreshState createState() => _MyEasyRefreshState();
}

class _MyEasyRefreshState extends State<MyEasyRefresh> {

  //创建时间对象，获取当前时间
  DateTime now = new DateTime.now();

//  print("日本于${victoryDay.year}年${victoryDay.month}月${victoryDay.day}日在南京签署中国战区投降书");

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: ClassicalHeader(
        enableInfiniteRefresh: false,
        refreshText: '下拉刷新',
        refreshReadyText: '释放刷新',
        refreshingText: '正在刷新',
        refreshedText: '刷新完成',
        refreshFailedText: '刷新失败',
        noMoreText: '没有更多',
        textColor: Colours.appbar_red,
        infoText: '更新于 ${now.hour}:${now.second}',
        bgColor: Colors.white,
        infoColor: Colours.appbar_red,
        float: false,
        enableHapticFeedback: true,
      ),
      footer: ClassicalFooter(
        enableInfiniteLoad: true,
        loadText: '上拉加载',
        loadReadyText: '释放加载',
        loadingText: '加载中',
        loadedText: '加载完成',
        loadFailedText: '加载失败',
        noMoreText: '已经到底了哦',
        infoText: '更新于 ${now.hour}:${now.second}',
        textColor: Colours.appbar_red,
        bgColor: Colors.white,
        infoColor: Colours.appbar_red,
        enableHapticFeedback: true,
        triggerDistance: 100.0,
      ),
      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      firstRefresh: false,
      controller: widget.easyRefreshController,
      onRefresh: widget.onRefresh != null
          ? () async {
              await Future.delayed(Duration(seconds: 1), widget.onRefresh);
            }
          : null,
      onLoad: widget.onLoad != null
          ? () async {
              await Future.delayed(Duration(seconds: 1), widget.onLoad);
            }
          : null,
//      emptyWidget: _count == 0 ? Container(
//        height: double.infinity,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Expanded(child: SizedBox(), flex: 2,),
//            SizedBox(
//              width: 100.0,
//              height: 100.0,
//              child: Image.asset('assets/image/nodata.png'),
//            ),
//
//            Expanded(child: SizedBox(), flex: 3,),
//          ],
//        ),
//      ): null,
      child: widget.child,
    );
  }
}

class MyEasyRefreshSliver extends StatefulWidget {
  EasyRefreshController easyRefreshController;
  ScrollController scrollController;

  Function onRefresh;
  Function onLoad;
  List<Widget> slivers;

  MyEasyRefreshSliver(
      {Key key,
      this.easyRefreshController,
      this.onRefresh,
      this.onLoad,
      this.scrollController,
      this.slivers});

  @override
  _MyEasyRefreshStateSliver createState() => _MyEasyRefreshStateSliver();
}

class _MyEasyRefreshStateSliver extends State<MyEasyRefreshSliver> {
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      header: ClassicalHeader(
        enableInfiniteRefresh: false,
        refreshText: '下拉刷新',
        refreshReadyText: '释放刷新',
        refreshingText: '正在刷新',
        refreshedText: '刷新完成',
        refreshFailedText: '刷新失败',
        noMoreText: '没有更多',
        textColor: Colors.red,
        infoText: '更新于 10:10',
        bgColor: Colors.white,
        infoColor: Colors.red,
        float: false,
        enableHapticFeedback: true,
      ),
      footer: ClassicalFooter(
        enableInfiniteLoad: true,
        loadText: '上拉加载',
        loadReadyText: '释放加载',
        loadingText: '加载中',
        loadedText: '加载完成',
        loadFailedText: '加载失败',
        noMoreText: '已经到底了哦',
        infoText: '更新于 10:10',
        textColor: Colors.red,
        bgColor: Colors.white,
        infoColor: Colors.red,
        enableHapticFeedback: true,
//        triggerDistance: 100.0,
      ),
      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      firstRefresh: true,
      controller: widget.easyRefreshController,
      onRefresh: widget.onRefresh,
      onLoad: widget.onLoad,
      scrollController: widget.scrollController,
//      emptyWidget: _count == 0 ? Container(
//        height: double.infinity,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Expanded(child: SizedBox(), flex: 2,),
//            SizedBox(
//              width: 100.0,
//              height: 100.0,
//              child: Image.asset('assets/image/nodata.png'),
//            ),
//
//            Expanded(child: SizedBox(), flex: 3,),
//          ],
//        ),
//      ): null,
      slivers: widget.slivers,
    );
  }
}
