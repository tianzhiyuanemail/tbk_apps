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
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/sort_modle.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/res_list_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/my_easy_refresh.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:tbk_app/widgets/product_silvrs_sort_static_bar_widget.dart';

import '../../entity_list_factory.dart';

class HomePageOther extends StatefulWidget {
  HomeCateEntity homeCateEntity;

  HomePageOther({Key key, this.homeCateEntity});

  @override
  _HomePageOtherState createState() => _HomePageOtherState();
}

class _HomePageOtherState extends State<HomePageOther>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();

  EasyRefreshController _easyRefreshController;

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  bool noMore = false;

  List<ProductListEntity> goodsList = [];
  int page = 0;
  int totalCount = 0;

  SortModle _sortModle = new SortModle();

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

    _easyRefreshController = EasyRefreshController();

    super.initState();
  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
//    _easyRefreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: MyEasyRefresh(
        easyRefreshController: _easyRefreshController,
        onRefresh: () async {
          setState(() {
            page = 0;
          });
          _easyRefreshController.resetLoadState();

          _getGoods();
        },
        onLoad: () async {
          _easyRefreshController.finishLoad(noMore: noMore);

          _getGoods();
        },
        child: CustomScrollView(
          controller: _controller,
          reverse: false,
          slivers: <Widget>[
            CateHot(homeCateEntity: widget.homeCateEntity),
            SecondaryCategory(homeCateEntity: widget.homeCateEntity),
            SliverSortStaticyBar.buildStickyBar(_sortModle,
                (SortModle sortModle) {
              setState(() {
                _sortModle = sortModle;
                page = 0;
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

  void _getGoods() {
    Map<String, Object> map = Map();
    map["cateId"] = widget.homeCateEntity.cateId;
    map["pageNo"] = page;
    map["sort"] = _sortModle.s1 + _sortModle.s2;

    HttpUtil()
        .get('getProductList', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        List<ProductListEntity> list =
            EntityListFactory.generateList<ProductListEntity>(val['data']);
        ResListEntity resListEntity =
            ResListUtil.buildResList(goodsList, list, page, noMore);

        setState(() {
          print(val["message"]);
          goodsList = resListEntity.list;
          noMore = resListEntity.noMore;
          page = resListEntity.page;
        });
      } else {
        setState(() {
          print(val["message"]);
          goodsList = List();
          noMore = true;
        });
      }
    });
  }
}

class CateHot extends StatelessWidget {
  HomeCateEntity homeCateEntity;

  CateHot({Key key, @required this.homeCateEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {},
        child: loadNetworkImage(homeCateEntity.image),
      ),
    );
  }
}

class SecondaryCategory extends StatelessWidget {
  HomeCateEntity homeCateEntity;

  SecondaryCategory({Key key, @required this.homeCateEntity}) : super(key: key);

  Widget _itemUI(BuildContext context, CateEntity cateEntity) {
    return InkWell(
      onTap: () {
        Toast.show(cateEntity.cateName);
        NavigatorUtil.push(
            context,
            Routers.productListPage +
                "?cateId=${cateEntity.cateId}&cateName=${FluroConvertUtils.fluroCnParamsEncode(cateEntity.cateName)}");
      },
      child: Column(
        children: <Widget>[
          loadNetworkImage(
            cateEntity.cateIcon,
            width: ScreenUtil().setHeight(60),
          ),
          Text(
            cateEntity.cateName,
            style: TextStyles.textNormal14,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: ScreenUtil().setHeight(270),
        margin: EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(4.0),
          children: homeCateEntity.data.asMap().keys.map((key) {
            if (key < 10) {
              return _itemUI(context, homeCateEntity.data[key]);
            } else {
              return Container();
            }
          }).toList(),
        ),
      ),
    );
  }
}
