/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/provide/child_cate.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/widgets/app_bar.dart';

import '../../entity_list_factory.dart';

class CatePage extends StatefulWidget {
  @override
  _CatePageState createState() => _CatePageState();
}

class _CatePageState extends State<CatePage>
    with SingleTickerProviderStateMixin {
  List<CateEntity> list = [];
  Animation<double> numberAnimation;
  AnimationController controller;
  double selectIndex = 0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController =
        new ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _changeSelected(selectIndex, 0);
    _cateGetList();
  }

  void _cateGetList() {
    HttpUtil().get('cateGetList').then((val) {
      if (val["success"]) {
        setState(() {
          list = EntityListFactory.generateList<CateEntity>(val['data']);
          _updateCateChild(0);
        });
      } else {
        setState(() {
          print(val["message"]);
          list = List();
        });
      }
    });
  }

  @override
  dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "商品分类",
      ),
      body: list.length == 0
          ? Container(
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(750),
              child: CircularProgressIndicator(),
            )
          : Container(
              width: ScreenUtil.screenWidth,
              child: Row(
                children: <Widget>[
                  leftWidget(),
                  rightWidget(),
                ],
              ),
            ),
    );
  }

  /// 切换选择
  _changeSelected(double begin, double end) {
    numberAnimation = new Tween(begin: begin, end: end).animate(controller)
      ..addListener(() {
        setState(() {
          selectIndex = numberAnimation.value;
        });
      });
    controller.forward(from: 0.0);
  }

  /// 初始化二级类目
  _updateCateChild(int index) {
    List<CateEntity> childCate = list[index.toInt()].data;
    Provide.value<ChildCate>(context).getChildCate(childCate);
  }

  Widget _item(double index) {
    bool _selected = selectIndex.toInt() == index.toInt();

    return InkWell(
      onTap: () {
        _changeSelected(selectIndex, index);
        //_animateTo(index);
        _updateCateChild(index.toInt());
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        height: ScreenUtil().setWidth(50),
        alignment: Alignment.center,
        decoration: _selected
            ? BoxDecoration(
                color: Colours.appbar_red,
                border: Border.all(
                  width: 2.0,
                  color: Colours.appbar_red,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              )
            : BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.transparent),
              ),
        child: Text(
          list[index.toInt()].cateName.toString(),
          style: TextStyle(
            color: _selected ? Colors.white : Colors.black,
            letterSpacing: 15,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }

  ///   ---------------------------------leftWidget-------------------------------------------------

  Widget leftWidget() {
    return Container(
      width: ScreenUtil().setWidth(200),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(width: 2, color: Colors.black12),
          )),
      child: ListView(
        children: list.asMap().keys.map((v) {
          return _item(v.toDouble());
        }).toList(),
      ),
    );
  }

  ///   ---------------------------------rightWidget-------------------------------------------------

  Widget rightWidget() {
    return Container(
      width: ScreenUtil().setWidth(550),
      child: Provide<ChildCate>(
        builder: (context, child, data) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black12),
              ),
            ),
            child: rightList(data.chileCate),
          );
        },
      ),
    );
  }

  Widget rightList(List<CateEntity> cateChild) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5.0,
      childAspectRatio: 0.7,
      children: cateChild.map((cate) {
        return InkWell(
          onTap: () {
            NavigatorUtil.push(
                context,
                Routers.productListPage +
                    "?cateId=${cate.cateId}&cateName=${FluroConvertUtils.fluroCnParamsEncode(cate.cateName)}");
          },
          child: Container(
            padding: EdgeInsets.all(23),
            child: Column(
              children: <Widget>[
                loadNetworkImage(
                  cate.cateIcon,
                  width: ScreenUtil().setWidth(150),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    cate.cateName,
                    style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
