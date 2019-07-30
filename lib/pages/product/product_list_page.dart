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
import 'package:tbk_app/modle/sort_modle.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:tbk_app/widgets/product_silvrs_sort_static_bar_widget.dart';

import '../../entity_list_factory.dart';

class ProductListPage extends StatefulWidget {
  String cateId;
  String cateName;

  ProductListPage(this.cateId,this.cateName);

  @override
  _ProductListPage createState() => _ProductListPage();
}

class _ProductListPage extends State<ProductListPage>
    with AutomaticKeepAliveClientMixin {

  ScrollController _controller = new ScrollController();
  GlobalKey<RefreshFooterState> _refreshFooterState =
  GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
  GlobalKey<RefreshHeaderState>();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  List<ProductListEntity> goodsList = [];
  int page = 1;
  /// 排序相关
  SortModle _sortModle = new SortModle();

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

  void _getGoods() {

    Map<String, Object> map  = Map();
    map["cateId"] =  widget.cateId;
    map["pageNo"] = page;
    map["sort"] = _sortModle.s1+_sortModle.s2;

    HttpUtil().get('getProductList',parms: MapUrlParamsUtils.getUrlParamsByMap(map)).then((val) {
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




//    getHttpRes('getProductList', MapUrlParamsUtils.getUrlParamsByMap(map)).then((val) {
//      if (val["success"]) {
//        List<ProductListEntity> list = EntityListFactory.generateList<
//            ProductListEntity>(val['data']);
//        setState(() {
//          if (page == 1) {
//            goodsList = list;
//          } else {
//            goodsList.addAll(list);
//          }
//          page++;
//        });
//      } else {
//        setState(() {
//          print(val["message"]);
//          goodsList = List();
//          page = 1;
//        });
//      }
//    }
//      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.pink,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back_ios,
//            color: Colors.white,
//          ),
//          onPressed: () {
//            Application.router.pop(context);
//          },
//        ),
//        //导航栏和状态栏的的颜色
//        elevation: 0,
//        //阴影的高度
//        brightness: Brightness.light,
//        centerTitle: true,
//        //标题是否居中，默认为false
//        //        toolbarOpacity: 0.5, //整个导航栏的不透明度
//        bottomOpacity: 1,
//        //bottom的不透明度
//        titleSpacing: 5,
//        //标题两边的空白区域,
//        title: Text(widget.cateName)
//      ),
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
          title: Text(widget.cateName,style: TextStyle(fontSize: 15),),

          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              NavigatorUtil.gotransitionPop(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight*0.025),
      ),
      floatingActionButton: BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
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
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverSortStaticyBar.buildStickyBar(_sortModle,
                    (SortModle sortModle) {
                  setState(() {
                    _sortModle = sortModle;
                    page = 1;
                  });
                  _getGoods();
                }),
            SliverProductList(
              list: goodsList,
              crossAxisCount: _sortModle.crossAxisCount,
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
    _controller.dispose();
    super.dispose();
  }
}
