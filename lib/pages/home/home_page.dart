/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/tab_item_modle.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/widgets/search_text_field_widget.dart';

import 'hom_page_other.dart';
import 'home_page_first.dart';

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
  List<TabItem> titleList = [
    TabItem("首页", "", "", true),
    TabItem("猜你喜欢", "", "", true),
    TabItem("母婴", "", "", true),
    TabItem("食品", "", "", true),
    TabItem("女装", "", "", true),
    TabItem("彩妆", "", "", true),
    TabItem("洗护", "", "", true),
    TabItem("内衣", "", "", true),
    TabItem("百货", "", "", true),
    TabItem("家电", "", "", true),
    TabItem("家居", "", "", true),
    TabItem("数码", "", "", true)
  ];

  TabController tabController;
  var hintText = "替换这里的文字";

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: titleList.length);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return DefaultTabController(
        length: titleList.length,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.04),
              child: AppBar(
                backgroundColor: Colors.white,
                //导航栏和状态栏的的颜色
                elevation: 0,
                //阴影的高度
                brightness: Brightness.light,
                //控制状态栏的颜色，lignt 文字是灰色的，dark是白色的
                iconTheme: IconThemeData(
                  color: Colors.black45,
                  opacity: 0.5,
                  size: 30,
                ),
                //icon的主题样式,默认的颜色是黑色的，不透明为1，size是24
                textTheme: TextTheme(),
                //这个主题的参数比较多,flutter定义了13种不同的字体样式
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
                        style: TextStyle(color: Colors.black45),
                      ),
                    );
                  },
                ),
                title: SearchTextFieldWidget(
                  hintText: "搜索什么",
                  onTab: () {
                    NavigatorUtil.gotransitionPage(context, Routers.searchPage);
                  },
                ),

                actions: <Widget>[
                  IconButton(
                    color: Colors.black45,
                    icon: Icon(Icons.border_horizontal),
                    // tooltip: 'Restitch it',
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
                  child: TabBars(tabController: tabController, list: titleList),
                  preferredSize:  Size(10, 10),
                ),
              )),
          body: new Container(
            color: Colors.white,
            child: new SafeArea(
              child: TabBarViews(tabController: tabController, titleList: titleList),
            ),
          ),
        ));
  }
}

class TabBars extends StatelessWidget {
  final TabController tabController;
  final List<TabItem> list;

  TabBars({Key key, @required this.tabController, @required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      height: 35,
      child: TabBar(
        tabs: list
            .map((tabItem) => tabItem.isName
                ? Text(tabItem.name, style: TextStyle(fontSize: 15))
                : Image.network(tabItem.img))
            .toList(),
        isScrollable: true,
        controller: tabController,
        indicatorColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
        labelColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
        labelStyle: TextStyle(fontSize: 18, color: Colors.black45),
        unselectedLabelColor: Colors.black45,
        unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.black45),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}

class  TabBarViews extends StatelessWidget {
  final TabController tabController;
  final List titleList;

  TabBarViews({Key key, @required this.tabController,@required this.titleList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewList = [];

    viewList =  titleList.asMap().keys.map((key){
      if (key == 0){
        return HomePageFirst();
      }else if(key == 1){
        return Page2();
      }else{
        return HomePageOther();
      }
    }).toList();


    return TabBarView(
      children: viewList,
      controller: tabController,
    );
  }
}



class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page2');
    return Center(
      child: Text('猜你喜欢页面'),
    );
  }
}

