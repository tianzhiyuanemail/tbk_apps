/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_header.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_menu.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_menu_controller.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/res_list_util.dart';
import 'package:tbk_app/widgets/MyScaffold.dart';
import 'package:tbk_app/widgets/my_easy_refresh.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';

import '../../entity_list_factory.dart';

class ProductListPage extends StatefulWidget {
  String cateId;
  String cateName;

  ProductListPage(this.cateId, this.cateName);

  @override
  _ProductListPage createState() => _ProductListPage();
}

class _ProductListPage extends State<ProductListPage>
    with AutomaticKeepAliveClientMixin {
  /// 列表相关类
  ScrollController _scrollController;
  EasyRefreshController _easyRefreshController;
  ResListEntity<ProductListEntity> _listEntity = new ResListEntity(
      list: new List<ProductListEntity>(), page: 0, hasMore: false);

  /// 排序相关类
  GZXDropdownMenuController _dropdownMenuController;
  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();
  SortModle _sortModle = SortModle(
      sortStr: SortConstant.map['综合'],
      single: false,
      zongheSortConditions: SortConstant.zongheSortConditions,
      title: SortConstant.zongheSortConditions[0].name);

  @override
  void initState() {
    _getList(reset: true);
    _scrollController = new ScrollController();
    _easyRefreshController = EasyRefreshController();

    _dropdownMenuController = GZXDropdownMenuController();
    super.initState();
  }

  void _getList({bool reset = false}) {
    if (reset) {
      setState(() {
        _listEntity.page = 0;
        _listEntity.hasMore = false;
      });
    }
    Map<String, Object> map = Map();
    map["cateId"] = widget.cateId;
    map["pageNo"] = _listEntity.page;
    map["sort"] = _sortModle.sortStr;

    HttpUtil()
        .get('getProductList', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        List<ProductListEntity> list =
        EntityListFactory.generateList<ProductListEntity>(val['data']);
        ResListEntity resListEntity =
        ResListUtil.buildResList(_listEntity, list);
        setState(() {
          _listEntity = resListEntity;
        });
      } else {
        setState(() {
          print(val["message"]);
          _listEntity.list = List();
          _listEntity.hasMore = true;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Colours.appbar_red,
          title: Text(
            widget.cateName,
            style: TextStyle(fontSize: 15),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              NavigatorUtil.goBack(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.025),
      ),
      globalKey: _scaffoldKey,
//      endDrawer: Container(
//        margin: EdgeInsets.only(
//            left: MediaQuery.of(context).size.width / 5, top: 0),
//        color: Colors.white,
//        child: ListView(
//          children: <Widget>[TextField()],
//        ),
//      ),
      backTop: true,
      scrollController: _scrollController,
      stackKey: _stackKey,
      issort: true,
      sortFilter: GZXDropDownMenu(
        // controller用于控制menu的显示或隐藏
        controller: _dropdownMenuController,
        // 下拉菜单显示或隐藏动画时长
        animationMilliseconds: 500,
        // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
        menus: [
          GZXDropdownMenuBuilder(
              dropDownHeight: 40.0 * 4,
              dropDownWidget: GZXDropDownMenu.buildConditionListWidget(
                  _sortModle.zongheSortConditions, (value) {
                setState(() {
                  _sortModle.title = value.name;
                  _sortModle.sortStr = SortConstant.map[value.name];
                });
                _getList(reset: true);
                _dropdownMenuController.hide();
              })),
        ],
      ),
      body: MyEasyRefresh(
        easyRefreshController: _easyRefreshController,
        onRefresh: () async {
          _easyRefreshController.resetLoadState();
          _getList(reset: true);
        },
        onLoad: () async {
          _easyRefreshController.finishLoad(noMore: _listEntity.hasMore);
//          _getList(reset: false);
        },
        child: CustomScrollView(
          controller: _scrollController,
          reverse: false,
          slivers: <Widget>[
            GZXDropDownHeader(
              // 下拉的头部项 修改
              title: _sortModle.title,
              sortModle: _sortModle,
              onTap1: (SortModle modle) {
                setState(() {
                  _sortModle = modle;
                });
                _getList(reset: true);
              },
              onTap2: (SortModle modle) {
                setState(() {
                  _sortModle = modle;
                });
              },
              // GZXDropDownHeader对应第一父级Stack的key
              stackKey: _stackKey,
              scaffoldKey: _scaffoldKey,
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
            ),
            SliverProductList(
              list: _listEntity.list,
              hasMore:  _listEntity.hasMore,
              single: _sortModle.single,
              onLoad:  _getList,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }

}
