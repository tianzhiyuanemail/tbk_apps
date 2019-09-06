/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/tab_item_modle.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/image_text_click_item.dart';
import 'package:tbk_app/widgets/my_search_card.dart';
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
  List<String> searchHintTexts = [
    '显示器4k',
    '显示器4k 144hz',
    '显示器4k 曲面',
    '电脑显示器4k',
    '显示器4k二手',
    '显示器27英寸4k',
    'aoc4k显示器',
    '显示器4k24寸',
    '43寸4k显示器',
    '4k显示器 曲面屏',
    'lg4k显示器',
  ];

  TextEditingController _keywordTextEditingController = TextEditingController();
  FocusNode _focus = new FocusNode();


  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: homeCateList.length);

    tabController.addListener(() {//TabBar的监听
      if (tabController.indexIsChanging) {//判断TabBar是否切换
        print(tabController.index);
        Toast.show("${homeCateList[tabController.index].cateName}");
      }
    });
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
//        backgroundColor: GZXColors.mainBackgroundColor,
        appBar: HomeAppBar(
          leadingText: "乐享",
          title: GZXSearchCardWidget(
            elevation: 0,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              NavigatorUtil.push(context, Routers.searchPage);
            },
            textEditingController: _keywordTextEditingController,
            focusNode: _focus,
          ),
          bottom: PreferredSize(
            child: _buildTabBars(),
            preferredSize: Size(10, 10),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                margin: EdgeInsets.only(right: 6.0,left: 4,top: 12),
                height: 30,
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      GZXIcons.scan,
                      color: Colours.white,
                      size: 18,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Expanded(
                      child: Text(
                        '扫一扫',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colours.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // tooltip: 'Restitch it',
              onTap: () {
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
                .map((homeCate) => Text(homeCate.cateName, style: TextStyles.textWhite14))
                .toList(),
            isScrollable: true,
            controller: tabController,
            indicatorColor: Colours.white,
            labelColor: Colours.white,
            labelStyle: TextStyle(fontSize: 18, color: Colors.white),
            unselectedLabelColor: Colors.white,
            unselectedLabelStyle:
            TextStyle(fontSize: 18, color: Colours.white,),
            indicatorSize: TabBarIndicatorSize.label,

          ),
        ),
        Positioned(
            key: _buttonKey,
            right: 0,
            top: 5,
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.only(left: 10, right: 13, bottom: 0),
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
    var a = button.localToGlobal(Offset(0.0, button.size.height +5 ),
        ancestor: overlay);
    // 获得控件右下方的坐标
    var b = button.localToGlobal(button.size.bottomLeft(Offset(0,5)),
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
          color: Colors.white,
          padding: EdgeInsets.all(10),
          height: body.size.height,
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
                image:   homeCateList[index].cateIcon,
                onTap: () {
                  tabController.animateTo(index);
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
