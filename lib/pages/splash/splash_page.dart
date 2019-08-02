import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


import 'package:flukit/flukit.dart';
import 'package:tbk_app/config/loading.dart';
import 'package:tbk_app/constant/constant.dart';
import 'package:tbk_app/modle/splashModel.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/cache_network_image_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/sp_util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  TimerUtil _timerUtil;

  List<String> _guideList = [
    'assets/images/guide1.png',
    'assets/images/guide2.png',
    'assets/images/guide3.png',
  ];

  List<Widget> _bannerList = new List();

  int _status = 0;
  int _count = 3;

  splashModel _splashModel = splashModel();

  @override
  void initState() {
    super.initState();
    /// 初始化
    _initAsync();
  }

  void _initAsync() async {
    await SpUtil.getInstance();
    _splashModel.image = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562757288566&di=d2a66fc564ec399b02919be1792e420d&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F8326cffc1e178a82c4403d44f803738da877e8d2.jpg';

    Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
      SpUtil.putBool(Constant.key_guide, false);
      bool b = SpUtil.getBool(Constant.key_guide, defValue: true);
      if (b && ObjectUtil.isNotEmpty(_guideList)) {
        SpUtil.putBool(Constant.key_guide, false);
        _initBanner();
      } else {
        _initSplash();
      }
    });
  }


  /// 初始化 引导页
  void _initBanner() {
    _initBannerData();
    setState(() {
      _status = 2;
    });
  }
  /// 初始化 引导页 widget
  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      if (i == length - 1) {
        _bannerList.add(new Stack(
          children: <Widget>[
            new Image.asset(
              _guideList[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 160.0),
                child: new InkWell(
                  onTap: () {
                    _goMain();
                  },
                  child: new CircleAvatar(
                    radius: 48.0,
                    backgroundColor: Colors.indigoAccent,
                    child: new Padding(
                      padding: EdgeInsets.all(2.0),
                      child: new Text(
                        '立即体验',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      } else {
        _bannerList.add(new Image.asset(
          _guideList[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }

  /// 初始化 广告页
  void _initSplash() {
    if (_splashModel == null) {
      _goMain();
    } else {
      _doCountDown();
    }
  }

  void _doCountDown() {
    setState(() {
      _status = 1;
    });
    _timerUtil = new TimerUtil(mTotalTime: 2 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _goMain();
      }
    });
    _timerUtil.startCountDown();
  }

  void _goMain() {
    NavigatorUtil.gotransitionPage(context,Routers.root );

  }

  Widget _buildSplashBg() {
    return new Image.asset(
      'assets/images/splash_bg.png',
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  Widget _buildAdWidget() {
    if (_splashModel == null || _splashModel.image == null) {
      return new Container(
        height: 0.0,
      );
    }
    return new Offstage(
      offstage: !(_status == 1),
      child: new InkWell(
        onTap: () {
//          NavigatorUtil.pushWeb(context, title: _splashModel.title, url: _splashModel.url);
        },
        child:  CacheNetworkImageUtil.image(_splashModel.image, 'assets/images/splash_bg.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          ),
          new Offstage(
            offstage: !(_status == 2),
            child: ObjectUtil.isEmpty(_bannerList)
                ? new Container()
                : new Swiper(
                    autoStart: false,
                    circular: false,
                    indicator: CircleSwiperIndicator(
                      radius: 4.0,
                      padding: EdgeInsets.only(bottom: 30.0),
                      itemColor: Colors.black26,
                    ),
                    children: _bannerList,
            ),
          ),
          _buildAdWidget(),
          new Offstage(
            offstage: !(_status == 1),
            child: new Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  _goMain();
                },
                child: new Container(
                    padding: EdgeInsets.all(12.0),
                    child: new Text(
                      '$_count',
                      style: new TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    decoration: new BoxDecoration(
                        color: Color(0x66000000),
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        border: new Border.all(
                            width: 0.33))),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerUtil != null) _timerUtil.cancel(); //记得中dispose里面把timer cancel。
  }
}
