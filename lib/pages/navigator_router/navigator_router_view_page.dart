/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/sort_modle.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:tbk_app/widgets/product_silvrs_sort_static_bar_widget.dart';

import '../../entity_list_factory.dart';

class NavigatorRouterViewPage extends StatefulWidget {
  final int materialId ;

  NavigatorRouterViewPage(this.materialId);

  @override
  _NavigatorRouterViewPageState createState() => _NavigatorRouterViewPageState();
}

class _NavigatorRouterViewPageState extends State<NavigatorRouterViewPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();

  GlobalKey<RefreshFooterState> _refreshFooterState =
  GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
  GlobalKey<RefreshHeaderState>();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  List<ProductListEntity> goodsList = [];
  int page = 0;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getGoods();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          setState(() {
            showToTopBtn = false;
          });
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: EasyRefresh(
        refreshFooter: EasyRefreshUtil.classicsFooter(_refreshFooterState),
        refreshHeader: EasyRefreshUtil.classicsHeader(_refreshHeaderState),
        loadMore: () async {
          _getGoods();
        },
        onRefresh: () async {
          setState(() {
            page = 1;
          });
          _getGoods();
        },
        child: ListView(
          controller: _controller,
          children: <Widget>[
            ProductList(
              list: goodsList,
              crossAxisCount: 1,
            ),
          ],
        ),
      ),
    );
  }


  void _getGoods() {

    Map<String, Object> map  = Map();
    map["materialId"] =   widget.materialId;
    map["pageNo"] =   page;

    HttpUtil().get('choiceMaterial',parms: MapUrlParamsUtils.getUrlParamsByMap(map)).then((val) {
      if(val["success"]){
        List<ProductListEntity> list = EntityListFactory.generateList<ProductListEntity>(val['data']);
        setState(() {
          if (page == 1){
            goodsList = list;
          }else{
            goodsList.addAll(list);
          }
          page++;
        });
      }else{
        setState(() {
          print(val["message"]);
          goodsList = List();
          page  = 1;
        });
      }
    });
  }
}
