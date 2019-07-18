/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/util/colors_util.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  var userAvatar = "http://kaze-sora.com/sozai/blog_haru/blog_mitubachi01.jpg";
  var userName = 'rre';

  ScrollController _scrollController = ScrollController();

  bool hidden = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 120) {
        setState(() {
          hidden = true;
        });
      } else {
        setState(() {
          hidden = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new NestedScrollView(
        headerSliverBuilder: _headerSliverBuilder,
        controller: _scrollController,
        reverse: false,
        body: Container(
          color: Colors.greenAccent,
          child: new ListView(
            children: <Widget>[
              UserRevenue(),
              AdBanner(),
              UserButtons(),
              UserTools(),
              UsersGrowthValue("24"),
            ],
          ),
        ));
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        //1.在标题左侧显示的一个控件，在首页通常显示应用的 logo；在其他界面通常显示为返回按钮
//        leading: Icon(Icons.add),
        //2. ? 控制是否应该尝试暗示前导小部件为null
        automaticallyImplyLeading: true,
        elevation: 4,
        //APP bar 的颜色，默认值为 ThemeData.primaryColor。改值通常和下面的三个属性一起使用
        backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
        //App bar 的亮度，有白色和黑色两种主题，默认值为 ThemeData.primaryColorBrightness
        brightness: Brightness.light,
        //App bar 上图标的颜色、透明度、和尺寸信息。默认值为 ThemeData().primaryIconTheme
        iconTheme: ThemeData().primaryIconTheme,
        //App bar 上的文字主题。默认值为 ThemeData（）.primaryTextTheme
        textTheme: ThemeData().accentTextTheme,
        //此应用栏是否显示在屏幕顶部
        primary: true,
        //标题是否居中显示，默认值根据不同的操作系统，显示方式不一样,true居中 false居左
        centerTitle: true,
        //横轴上标题内容 周围的间距
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        //展开高度
        expandedHeight: 120,
        //是否随着滑动隐藏标题
        floating: true,
        //tab 是否固定在顶部
        pinned: true,
        //与floating结合使用
        snap: true,
        actions: <Widget>[
          new IconButton(
            // action button
            icon: new Icon(Icons.add),
            onPressed: () {},
          ),
          new IconButton(
            // action button
            icon: new Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        //当前界面的标题文字
        title: hidden ? Text('我的页面') : null,
        //5.一个显示在 AppBar 下方的控件，高度和 AppBar 高度一样，
        // 可以实现一些特殊的效果，该属性通常在 SliverAppBar 中使用
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: UserInformation(),
        ),
      )
    ];
  }
}

/// 用户基本信息
class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          /// 左侧按钮
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 18, left: 15),
              child: Column(
                children: <Widget>[
                  /// 头像 昵称 邀请码
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 头像
                        Container(
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.50, color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: new NetworkImage(
                              'http://e.hiphotos.baidu'
                              '.com/image/pic/item/359b033b5bb5c9eac1754f45df39b6003bf3b396.jpg',
                            ),
                          ),
                        ),
                        // 昵称
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "木有昵称",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
                                        "超级会员",
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 10),
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
                                          "oiqher",
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
                                              color: Colors.white,
                                              fontSize: 10),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
              ),
            ),
            flex: 8,
          ),
        ],
      ),
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: NetworkImage(
//              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551944816841&di=329f747e3f4c2554f24c609fd6f77c49&imgtype=0&src=http%3A%2F%2Fimg.tupianzj.com%2Fuploads%2Fallimg%2F160610%2F9-160610114520.jpg"),
//          fit: BoxFit.cover,
//        ),
//      ),
    );
  }
}

/// 用户收益
class UserRevenue extends StatelessWidget {
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
      margin: EdgeInsets.only(bottom: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 40,
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
