/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';

/// Sliver 商品列表  SliverList
class SliverProductList extends StatelessWidget {
  final List list;
  final int crossAxisCount;

  SliverProductList({Key key, this.list, this.crossAxisCount})
      : super(key: key);

  /// 商品列表
  List<Widget> _getListVidget1(BuildContext context) {
    return list.map((obj) {
      return InkWell(
        onTap: () {
          Application.router.navigateTo(
              context, Routers.detailsPage + "?id=" + obj['numIid'].toString());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(250),
                child: Image.network(obj['pictUrl'],
                    width: ScreenUtil().setWidth(300)),
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
                        obj['title'],
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
                              "255  ",
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: ScreenUtil().setSp(35),
                              ),
                            ),
                          ),
                          Text(
                            "￥255",
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
                        "月销售7777笔",
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
                                color: Colors.pink.shade100,
                                border: Border.all(color: Colors.pink),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                '10元券',
                                style: TextStyle(
                                    color: Colors.pink,
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
                                color: Colors.pink,
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
          Application.router.navigateTo(
              context, Routers.detailsPage + "?id=" + obj['numIid'].toString());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(obj['pictUrl'], width: ScreenUtil().setWidth(370)),
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
                  "领券减10元",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26),
                  ),
                ),
              ),
              Text(
                obj['title'],
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
                     "255  ",
                     style: TextStyle(
                       color: Colors.pink,
                       fontSize: ScreenUtil().setSp(35),
                     ),
                   ),
                  ),
                  Text(
                    "￥255",
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
        return SliverGrid.count(
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
        return SliverGrid.count(
          crossAxisCount: 2,
          //横轴数量
          crossAxisSpacing: 7.0,
          //横轴间距
          mainAxisSpacing: 1.0,
          //纵轴间距
          childAspectRatio: 0.66,
          //横纵比例 长宽只能这个属性设置
          children: _getListVidget2(context),
        );
      }
    } else {
      return SliverToBoxAdapter(
        child: Text("正在加载"),
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

///  商品列表 GridView
class ProductListGridView extends StatelessWidget {
  final List list;

  ProductListGridView({Key key, this.list}) : super(key: key);

  /// 商品列表 双列构造
  List<Widget> _getListVidget(BuildContext context) {
    return list.map((obj) {
      return InkWell(
        onTap: () {
          Application.router.navigateTo(
              context, Routers.detailsPage + "?id=" + obj['numIid'].toString());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Column(
            children: <Widget>[
              Image(
                  image: CachedNetworkImageProvider(obj['pictUrl']),
                  width: ScreenUtil().setWidth(370)),
              Text(
                obj['title'],
                style: TextStyle(
                    color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Text("￥255"),
                  Text(
                    "￥255",
                    style: TextStyle(color: Colors.black12),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _List(BuildContext context) {
    if (list.length != 0) {
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
        children: _getListVidget(context),
      );
    } else {
      return Text("正在加载");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _List(context),
    );
  }
}

///  商品列表 ListView
class ProductListListView extends StatelessWidget {
  final List list;

  ProductListListView({Key key, this.list}) : super(key: key);

  /// 商品列表 单列构造
  List<Widget> _getListWidget(BuildContext context) {
    return list.map((obj) {
      return InkWell(
        onTap: () {
          Application.router.navigateTo(
              context, Routers.detailsPage + "?id=" + obj['numIid'].toString());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 3),
          child: Column(
            children: <Widget>[
              Image(
                  image: CachedNetworkImageProvider(obj['pictUrl']),
                  width: ScreenUtil().setWidth(370)),
              Text(
                obj['title'],
                style: TextStyle(
                    color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Text("￥255"),
                  Text(
                    "￥255",
                    style: TextStyle(color: Colors.black12),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _List(BuildContext context) {
    if (list.length != 0) {
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
        children: _getListWidget(context),
      );
    } else {
      return Text("正在加载");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _List(context),
    );
  }
}
