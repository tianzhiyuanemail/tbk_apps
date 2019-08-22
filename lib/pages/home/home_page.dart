/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/tab_item_modle.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/image_text_click_item.dart';
import 'package:tbk_app/widgets/popup_window.dart';

import '../../entity_list_factory.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<HomeCateEntity> homeCateList = EntityListFactory.generateList<HomeCateEntity>(SpUtil.getObjectList('homeCateList'));


  GlobalKey _buttonKey = GlobalKey();
  GlobalKey _bodyKey = GlobalKey();

  TabController tabController;
  var hintText = "替换这里的文字";

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: homeCateList.length);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: homeCateList.length,
      child: Scaffold(
        appBar: HomeAppBar(
          leadingText: "咸鱼",
          title: InkWell(
            onTap: () {
              NavigatorUtil.gotransitionPage(context, Routers.searchPage);
            },
            child: Container(
              child: loadAssetImage('sys/search_text'),
            ),
          ),
          bottom: PreferredSize(
            child: _buildTabBars(),
            preferredSize: Size(10, 10),
          ),
          actions: <Widget>[
            IconButton(
              icon: loadAssetImage('sys/scanning',width: 25,height: 25),
              // tooltip: 'Restitch it',
              onPressed: () {
                Toast.show("扫码");
              },
            ),
          ],
        ),
        body: Container(
          key: _bodyKey,
          color: Colors.white,
          child: new SafeArea(
            child: _buildTabBarViews(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBars() {
    return Stack(
      children: <Widget>[
        Container(
          height: 35,
          child: TabBar(
            tabs: homeCateList
                .map((homeCate) => Text(homeCate.cateName, style: TextStyles.textNormal14))
                .toList(),
            isScrollable: true,
            controller: tabController,
            indicatorColor: Colours.appbar_red,
            labelColor: Colours.appbar_red,
            labelStyle: TextStyle(fontSize: 18, color: Colors.black45),
            unselectedLabelColor: Colors.black45,
            unselectedLabelStyle:
                TextStyle(fontSize: 18, color: Colors.black45),
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        Positioned(
            key: _buttonKey,
            right: 0,
            top: 5,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
              child: GestureDetector(
                child: loadAssetImage("sys/expand", width: 25.0, height: 25.0),
                onTap: () {
                  _showSortMenu();
                },
              ),
            ))
      ],
    );
  }

  Widget _buildTabBarViews() {
    var viewList = [];

    viewList = homeCateList.asMap().keys.map((key) {
      if (key == 0) {
        return HomePageFirst();
      } else if (key == 1) {
        return Page2();
      } else {
        return HomePageOther(homeCateEntity:homeCateList[key]);
      }
    }).toList();

    return TabBarView(
      children: viewList,
      controller: tabController,
    );
  }

  _showSortMenu() {
    // 获取点击控件的坐标
    final RenderBox button = _buttonKey.currentContext.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    // 获得控件左下方的坐标
    var a = button.localToGlobal(Offset(0.0, button.size.height + 12.0),
        ancestor: overlay);
    // 获得控件右下方的坐标
    var b = button.localToGlobal(button.size.bottomLeft(Offset(0, 12.0)),
        ancestor: overlay);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(a, b),
      Offset.zero & overlay.size,
    );
    final RenderBox body = _bodyKey.currentContext.findRenderObject();
    showPopupWindow(
      context: context,
      fullWidth: true,
      position: position,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.goBack(context);
        },
        child: Container(
          color: Color(0x99000000),
          height: body.size.height - button.size.height + 10,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemCount: homeCateList.length,
            itemBuilder: (BuildContext context, int index) {
              return CateItem(
                title: homeCateList[index].cateName,
                image: "",
                onTap: () {
                  tabController.animateTo(index);
                  Toast.show("${homeCateList[index].cateName}");
                  NavigatorUtil.goBack(context);
                },
              );
            },
          ),
        ),
      ),
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
