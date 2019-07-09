/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/config/service_method.dart';
import 'package:tbk_app/config/service_url.dart';
import 'package:tbk_app/modle/tab_item_modle.dart';
import 'package:tbk_app/pages/home/tab_bar_view.dart';
import 'package:tbk_app/widgets/search_text_field_widget.dart';
import 'dart:math' as math;



/// 首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BookAudioVideoPageState();
  }
}

/// 首页 state
class _BookAudioVideoPageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<TabItem> titleList = [TabItem("首页", "","", true), TabItem("618", "","", true)];
  List<Widget> tabList = [];
  int tabsLength = 12;

  TabController tabController;
  var hintText = "替换这里的文字";

  @override
  void initState() {
    super.initState();
    this.getTabList();
    tabController = TabController(vsync: this, length: tabsLength);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return DefaultTabController(
        length: tabsLength,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            //导航栏和状态栏的的颜色
            elevation: 0,
            //阴影的高度
            brightness: Brightness.light,
            //控制状态栏的颜色，lignt 文字是灰色的，dark是白色的
            //        iconTheme: IconThemeData(
            //            color: Colors.yellow,
            //            opacity: 0.5,
            //            size: 30), //icon的主题样式,默认的颜色是黑色的，不透明为1，size是24
            //        textTheme: TextTheme(), //这个主题的参数比较多,flutter定义了13种不同的字体样式
            centerTitle: true,
            //标题是否居中，默认为false
            //        toolbarOpacity: 0.5, //整个导航栏的不透明度
            bottomOpacity: 0.8,
            //bottom的不透明度
            titleSpacing: 0,
            //标题两边的空白区域,

            // 左侧返回按钮，可以有按钮，可以有文字
            leading: Builder(
              builder: (BuildContext context) {
                return Align(
                  widthFactor: 10,
                  alignment: Alignment.center,
                  child: Text(
                    '咸鱼',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
            title: SearchTextFieldWidget(
              hintText: "搜索什么",
            ),
            actions: <Widget>[
              IconButton(
                color: Colors.black54,
                icon: Icon(Icons.border_horizontal),
                // tooltip: 'Restitch it',
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              child: Container(
                //color: Colors.white,
                height: 30,
                child: TabBar(
                  tabs: tabList,
                  isScrollable: true,
                  controller: tabController,
                  indicatorColor: Colors.yellowAccent,
                  labelColor: Colors.yellowAccent,
                  labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                  unselectedLabelColor: Colors.white,
                  unselectedLabelStyle:
                      TextStyle(fontSize: 18, color: Colors.white),
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
              preferredSize: Size(10, 10),
            ),
          ),
          body: new Container(
            color: Colors.white,
            child: new SafeArea(
              child: FlutterTabBarView(tabController: tabController, titleList: titleList),
            ),
          ),
        ));
  }

  void getTabList() {
    getHttpRes('cateListByPid', 'parentId=0').then((val) {
      setState(() {
        List cateList = val['data'] as List;
        titleList.addAll(cateList
            .map((cate) => TabItem(cate['tbkName'].toString(),
            cate['cateId'].toString(),"", true))
            .toList().sublist(0,10));

        tabList = titleList
            .map((tabItem) => tabItem.isName
                ? Text(tabItem.name, style: TextStyle(fontSize: 15))
                : Image.network(tabItem.img))
            .toList();
      });
    });
  }
}
