/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/loadingIndicator_util.dart';

import '../../entity_factory.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  UserInfoEntity userInfoEntity = new UserInfoEntity();
  ScrollController _scrollController = ScrollController();

  ///是否显示“返回到顶部”按钮
  bool controllerOffset = false;

  @override
  void initState() {
    super.initState();
//
    HttpUtil().get('getUser').then((val) {
      if (val["success"]) {
        setState(() {
          userInfoEntity =
              EntityFactory.generateOBJ<UserInfoEntity>(val['data']);
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.offset < 10 && controllerOffset) {
        setState(() {
          controllerOffset = false;
        });
      } else if (_scrollController.offset >= 10 && !controllerOffset) {
        setState(() {
          controllerOffset = true;
        });
      }
    });
  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: userInfoEntity == null
          ? LoadingIndicatorUtil()
          : Stack(
              children: <Widget>[
                Container(
                  color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(500),
                ),
                Container(
                  child: CustomScrollView(
                    controller: _scrollController,
                    reverse: false,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(_sliverListChild()),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              UserRevenue(userInfoEntity: userInfoEntity),
                              AdBanner(),
                              UserButtons(),
                              UserTools(),
                              UsersGrowthValue("24")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                HeaderChild(controllerOffset: controllerOffset),
              ],
            ),
    );
  }

  /// CustomScrollView _sliverListChild
  List<Widget> _sliverListChild() {
    List<Widget> list = List();

    list.add(UserInformation(
      userInfoEntity: userInfoEntity,
    ));

    return list;
  }
}

/// 自定义导航栏
class HeaderChild extends StatelessWidget {
  bool controllerOffset;

  HeaderChild({this.controllerOffset});

  @override
  Widget build(BuildContext context) {
    return controllerOffset
        ? Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 0, bottom: 0),
            padding: EdgeInsets.only(top: 14, bottom: 0),
            decoration: BoxDecoration(
              color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("       "),
                Container(
                    margin: EdgeInsets.only(left: 70),
                    child: Text(
                      "京淘优券",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: TopButton(),
                )
              ],
            ),
          )
        : Container();
  }
}

class TopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: (){
              NavigatorUtil.push(context, Routers.messagePage);
            },
            icon: loadAssetImage(
              "user/message",
              width: 24.0,
              height: 24.0,
            ),
          ),
          IconButton(
            onPressed: (){
              NavigatorUtil.push(context, Routers.settingPage);
            },
            icon: loadAssetImage(
              "user/setting",
              width: 24.0,
              height: 24.0,
            ),
          )
        ],
      ),
    );
  }
}

/// 用户基本信息
class UserInformation extends StatelessWidget {
  UserInfoEntity userInfoEntity;

  UserInformation({Key key, this.userInfoEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 0, left: 15, bottom: 15),
        width: ScreenUtil().setWidth(750),
        color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
        child: Column(
          children: <Widget>[
            /// 头像 昵称 邀请码
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // 头像
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.50, color: Colors.white),
                            borderRadius: BorderRadius.circular(50)),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              new NetworkImage("${userInfoEntity.avatarUrl}"),
                        ),
                      ),
                      // 昵称
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '${userInfoEntity.name}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, bottom: 1),
                                    child: Text(
                                      '${userInfoEntity.level}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: InkWell(
                                onTap: () {},
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "邀请码：",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, bottom: 1),
                                      child: Text(
                                        '${userInfoEntity.id}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, bottom: 1),
                                      child: Text(
                                        "复制",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //按钮
                  Container(
                    child: TopButton(),
                  )
                ],
              ),
            ),

            /// 粉丝 成长值
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "粉丝",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "0",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            "成长值",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "0",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

/// 用户收益
class UserRevenue extends StatelessWidget {
  UserInfoEntity userInfoEntity;

  UserRevenue({Key key, this.userInfoEntity});

  Widget _revenuNumber(String v1, String v2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
                text: "¥",
                style: new TextStyle(
                  fontSize: 11.0,
                  color: Colors.black54,
                ),
                children: [
                  TextSpan(
                    text: v1,
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.black54,
                    ),
                  )
                ]),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(v2),
        )
      ],
    );
  }

  Widget _lastMonthRevenuNumber(String v1, String v2) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Text.rich(
        TextSpan(
            text: v2,
            style: new TextStyle(
              fontSize: 11.0,
              color: Colors.black54,
            ),
            children: [
              TextSpan(
                text: '¥',
                style: new TextStyle(
                  fontSize: 11.0,
                  color: Colors.black54,
                ),
              ),
              TextSpan(
                text: v1,
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.black54,
                ),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _revenuNumber('0', '本月预估'),
                _revenuNumber('0', '今日收益'),
              ],
            ),
            Divider(
              height: 10.0,
              indent: 0.0,
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _lastMonthRevenuNumber('0', '上月结算'),
                _lastMonthRevenuNumber('0', '上月预估'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 广告
class AdBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(200),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551944816841&di=329f747e3f4c2554f24c609fd6f77c49&imgtype=0&src=http%3A%2F%2Fimg.tupianzj.com%2Fuploads%2Fallimg%2F160610%2F9-160610114520.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

///  收益 订单 粉丝 邀请 按钮
class UserButtons extends StatelessWidget {
  Widget _userButtonsChild(
      String assetsImages, String title, Function function) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: function,
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset(assetsImages, width: 30.0, height: 30.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _userButtonsChild('assets/images/ic_tab_home_active.png', '收益', () {
            print("收益");
          }),
          _userButtonsChild('assets/images/ic_tab_home_active.png', '订单', () {
            print("订单");
          }),
          _userButtonsChild('assets/images/ic_tab_home_active.png', '粉丝', () {
            print("粉丝");
          }),
          _userButtonsChild('assets/images/ic_tab_home_active.png', '邀请', () {
            print("邀请");
          }),
        ],
      ),
    );
  }
}

///  我的工具
class UserTools extends StatelessWidget {
  Widget _userToolsText() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20, top: 5, bottom: 3),
      child: Text("我的工具"),
    );
  }

  Widget _userToolsButton(
      String assetsImages, String title, Function function) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: function,
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset(assetsImages, width: 30.0, height: 30.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _userToolsButtons() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 60,
        children: <Widget>[
          _userToolsButton('assets/images/ic_tab_home_active.png', '新手指导', () {
            print("收益");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '我的收藏', () {
            print("订单");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '常见问题', () {
            print("粉丝");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '我的客服', () {
            print("邀请");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '官方公告', () {
            print("收益");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '订单查询', () {
            print("订单");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '商务合作', () {
            print("粉丝");
          }),
          _userToolsButton('assets/images/ic_tab_home_active.png', '关于我们', () {
            print("邀请");
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          _userToolsText(),
          Divider(height: 10.0, indent: 0.0, color: Colors.black12),
          _userToolsButtons(),
        ],
      ),
    );
  }
}

///  我的成长值
class UsersGrowthValue extends StatelessWidget {
  String growthValue = '24';

  UsersGrowthValue(this.growthValue);

  Widget _userToolsText() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20, top: 5, bottom: 3),
      child: Text("我的工具"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          _growthValue(),
          _imageInkWell(),
        ],
      ),
    );
  }

  _growthValue() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20, top: 5, bottom: 3),
            child: Row(
              children: <Widget>[
                Text("我的成长值"),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    growthValue,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 20),
              child: Row(
                children: <Widget>[
                  Text("提成成长值"),
                  Image.asset("assets/images/ic_tab_home_active.png",
                      width: 20.0, height: 20.0)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _imageInkWell() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551944816841&di=329f747e3f4c2554f24c609fd6f77c49&imgtype=0&src=http%3A%2F%2Fimg.tupianzj.com%2Fuploads%2Fallimg%2F160610%2F9-160610114520.jpg"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
