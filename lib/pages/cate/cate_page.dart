/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:tbk_app/config/service_method.dart';
import 'package:tbk_app/provide/child_cate.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';

class CatePage extends StatefulWidget {
  @override
  _CatePageState createState() => _CatePageState();
}

class _CatePageState extends State<CatePage>
    with SingleTickerProviderStateMixin {
  List list = [];
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

    getCatePage().then((val) {
      setState(() {
        list = val['data'] as List;
        _updateCateChild(0);
      });
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
    return Container(
      width: ScreenUtil.screenWidth,
      child: Row(
        children: <Widget>[
          leftWidget(),
          rightWidget(),
        ],
      ),
    );
  }

  /// 切换选择
  _changeSelected(double begin, double end) {
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    numberAnimation = new Tween(begin: begin, end: end).animate(controller)
      ..addListener(() {
        setState(() {
          selectIndex = numberAnimation.value;
        });
      });
    controller.forward(from: 0.0);
  }

  /// 滚动到选择的位置
  _animateTo(double index) {
    double scrollNumber = (index - 1) * 1580 / 50;
    _scrollController.animateTo(scrollNumber,
        duration: new Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// 初始化二级类目
  _updateCateChild(int index) {
    List childCate = list[index.toInt()]['data'] as List;
    Provide.value<ChildCate>(context).getChildCate(childCate);
  }

  Widget _item(double index) {
    bool _selected = selectIndex.toInt() == index.toInt();

    return InkWell(
      onTap: () {
        _changeSelected(selectIndex, index);
        _animateTo(index);
        _updateCateChild(index.toInt());
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        padding: EdgeInsets.only(top: 3, bottom: 3),
        height: ScreenUtil().setWidth(50),
        decoration: _selected
            ? BoxDecoration(
                color: Colors.redAccent,
                border: Border.all(width: 2.0, color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              )
            : BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.transparent),
              ),
        child: Text(
          list[index.toInt()]['tbkName'].toString(),
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
        controller: _scrollController,
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
        ));
  }

  Widget rightList(List cateChild) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5.0,
      childAspectRatio: 0.8,
      children: cateChild.map((cate) {
        return InkWell(
          onTap: () {
            NavigatorUtil.gotransitionPage(context, Routers.productListPage +
                "?cateId=" +
                cate["cateId"].toString() +
                "&cateName="+
                FluroConvertUtils.fluroCnParamsEncode(cate["tbkName"])
            );
          },
          child: Container(
            //width: 20,
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Image.network(
                  cate['tbkImg'],
                  width: ScreenUtil().setWidth(150),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    cate['tbkName'].toString().length > 2
                        ? cate['tbkName'].toString().substring(0, 2)
                        : cate['tbkName'].toString(),
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
