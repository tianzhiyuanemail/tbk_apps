/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_header.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_menu.dart';
import 'package:tbk_app/util/dropdown_menu/src/gzx_dropdown_menu_controller.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/res_list_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/widgets/MyScaffold.dart';
import 'package:tbk_app/widgets/my_easy_refresh.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';

import '../../entity_list_factory.dart';

// ignore: must_be_immutable
class HomePageOther extends StatefulWidget {
  HomeCateEntity homeCateEntity;

  HomePageOther({Key key, this.homeCateEntity});

  @override
  _HomePageOtherState createState() => _HomePageOtherState();
}

class _HomePageOtherState extends State<HomePageOther>
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getList(reset: true);
    _scrollController = new ScrollController();
    _easyRefreshController = EasyRefreshController();

    _dropdownMenuController = GZXDropdownMenuController();
    super.initState();
  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
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
            CateHot(homeCateEntity: widget.homeCateEntity),
            SecondaryCategory(homeCateEntity: widget.homeCateEntity),
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

  void _getList({bool reset = false}) {
    if (reset) {
      setState(() {
        _listEntity.page = 0;
        _listEntity.hasMore = false;
      });
    }
    Map<String, Object> map = Map();
    map["cateId"] = widget.homeCateEntity.cateId;
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
