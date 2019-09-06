/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/image_utils.dart';

/// Sliver 商品列表  SliverList
class SliverProductList extends StatelessWidget {
  final List<ProductListEntity> list;
  final bool single;
  final bool hasMore;
  final Function onLoad;

  SliverProductList({Key key, this.list, this.single,this.hasMore, this.onLoad})
      : super(key: key);

  /// 商品列表
  Widget _getWidget1(BuildContext context, int index) {
    ProductListEntity obj = list[index];
    if ((index + 3) == list.length && !hasMore) {
      print(
          'SearchResultListWidget.build next page,current data count ${list.length}');
      onLoad();
    }
    return InkWell(
      onTap: () {
        NavigatorUtil.push(
            context, "${Routers.detailsPage}?id=${obj.itemId}");
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(260),
              height: ScreenUtil().setHeight(260),
              child: loadNetworkImage("${obj.pictUrl}_310x310.jpg"),
            ),
            Container(
              width: ScreenUtil().setWidth(450),
              margin: EdgeInsets.only(left: 10, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${obj.shortTitle == null ? obj.title : obj.shortTitle}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(26),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
//                      width: ScreenUtil().setWidth(220),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "券后  ￥",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "${obj.afterCouponPrice}  ",
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: ScreenUtil().setSp(35),
                            ),
                          ),
                        ),
                        Text(
                          "￥${obj.zkFinalPrice}",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil().setSp(20),
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.dashed),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "月销售${obj.volume}笔",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil().setSp(20),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {},
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(50),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              border: Border.all(
                                color: Colours.appbar_red,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              '${obj.couponAmount}元券',
                              style: TextStyle(
                                  color: Colours.appbar_red,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {},
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(50),
                            decoration: BoxDecoration(
                              color:Colours.appbar_red,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              '领券',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 商品列表
  Widget _getWidget2(BuildContext context, int index) {
    ProductListEntity obj = list[index];
    if ((index + 4) == list.length && !hasMore) {
      print(
          'SearchResultListWidget.build next page,current data count ${list.length}');
      onLoad();
    }
    return InkWell(
      onTap: () {
        NavigatorUtil.push(
            context, Routers.detailsPage + "?id=${obj.itemId}");
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(350),
              height: ScreenUtil().setHeight(350),
              child: loadNetworkImage("${obj.pictUrl}_310x310.jpg"),
            ),
            Container(
              width: ScreenUtil().setWidth(370),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              child: Text(
                '${obj.couponInfo}',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
            ),
            Text(
              "${obj.shortTitle == null ? obj.title : obj.shortTitle}",
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(26)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "券后  ￥",
                  style: TextStyle(
                    color: Colors.pink.shade400,
                    fontSize: ScreenUtil().setSp(20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "${obj.afterCouponPrice}  ",
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: ScreenUtil().setSp(35),
                    ),
                  ),
                ),
                Text(
                  "￥${obj.zkFinalPrice}",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(20),
                      decoration: TextDecoration.lineThrough,
                      decorationStyle: TextDecorationStyle.dashed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _List(BuildContext context) {
    if (list.length != 0) {
      if (single) {
        return SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 2.3,
          ),
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _getWidget1(context, index);
            },
            childCount: list.length,
          ),
        );
      } else {
        return SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.6,
          ),
          delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _getWidget2(context, index);
            },
            childCount: list.length,
          ),
        );
      }
    } else {
      return SliverToBoxAdapter(
          child: Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(750),
        child: CircularProgressIndicator(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _List(context),
    );
  }
}

///  商品列表 GridView
class ProductList extends StatelessWidget {
  final List<ProductListEntity> list;
  final int crossAxisCount;

  ProductList({Key key, this.list, this.crossAxisCount}) : super(key: key);

  /// 商品列表
  List<Widget> _getListVidget1(BuildContext context) {
    return list.map((obj) {
      return InkWell(
        onTap: () {
          NavigatorUtil.push(
              context, "${Routers.detailsPage}?id=${obj.itemId}");
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(260),
                height: ScreenUtil().setHeight(260),
                child: loadNetworkImage("${obj.pictUrl}_310x310.jpg"),
              ),
              Container(
                width: ScreenUtil().setWidth(450),
                margin: EdgeInsets.only(left: 10, top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        obj.shortTitle == null || obj.shortTitle.isEmpty
                            ? obj.title
                            : obj.shortTitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(26),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
//                      width: ScreenUtil().setWidth(220),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "券后  ￥",
                            style: TextStyle(
                              color:Colours.appbar_red,
                              fontSize: ScreenUtil().setSp(20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "${obj.afterCouponPrice}  ",
                              style: TextStyle(
                                color: Colours.appbar_red,
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            ),
                          ),
                          Text(
                            "￥${obj.zkFinalPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(20),
                                decoration: TextDecoration.lineThrough,
                                decorationStyle: TextDecorationStyle.dashed),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        "月销售${obj.volume}笔",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil().setSp(20),
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {},
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setHeight(50),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                border: Border.all(
                                  color: Colours.appbar_red,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                '${obj.couponAmount}元券',
                                style: TextStyle(
                                    color: Colours.appbar_red,
                                    fontSize: ScreenUtil().setSp(20)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {},
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setHeight(50),
                              decoration: BoxDecoration(
                                color: Colours.appbar_red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                '领券',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  /// 商品列表
  List<Widget> _getListVidget2(BuildContext context) {
    return list.map((obj) {
      return InkWell(
        onTap: () {
          NavigatorUtil.push(
              context, "${Routers.detailsPage}?id=${obj.itemId}");
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(350),
                height: ScreenUtil().setHeight(350),
                child: loadNetworkImage("${obj.pictUrl}_310x310.jpg"),
              ),
              Container(
                width: ScreenUtil().setWidth(370),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                child: Text(
                  obj.couponInfo,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
              ),
              Text(
                obj.shortTitle.isEmpty ? obj.title : obj.shortTitle,
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(26)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "券后  ￥",
                    style: TextStyle(
                      color: Colors.pink.shade400,
                      fontSize: ScreenUtil().setSp(20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      obj.afterCouponPrice + "  ",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                  Text(
                    "￥${obj.zkFinalPrice}",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: ScreenUtil().setSp(20),
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.dashed),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _List(BuildContext context) {
    if (list.length != 0) {
      if (crossAxisCount == 1) {
        return GridView.count(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          //横轴数量
          crossAxisSpacing: 2.0,
          //横轴间距
          mainAxisSpacing: 1.0,
          //纵轴间距
          childAspectRatio: 2.2,
          //横纵比例 长宽只能这个属性设置
          children: _getListVidget1(context),
        );
      } else {
        return GridView.count(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          //横轴数量
          crossAxisSpacing: 1.0,
          //横轴间距
          mainAxisSpacing: 1.0,
          //纵轴间距
          childAspectRatio: 0.75,
          //横纵比例 长宽只能这个属性设置
          children: _getListVidget1(context),
        );
      }
    } else {
      return Container(
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(750),
        child: CupertinoActivityIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _List(context),
    );
  }
}
