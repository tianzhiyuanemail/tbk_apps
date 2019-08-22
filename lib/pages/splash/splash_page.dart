import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tbk_app/common/common.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/splashModel.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/util/utils.dart';

import '../../entity_list_factory.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  TimerUtil _timerUtil;



  List<String> _guideList = [
    'splash/app_start_1',
    'splash/app_start_2',
    'splash/app_start_3',
  ];
  int _status = 0;
  int _count = 3;
  splashModel _splashModel = splashModel();

  @override
  void initState() {
    super.initState();

    /// 初始化
    _initAsync();
    _getHomeCateList();
    setState(() {
      _splashModel.image =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562757288566&di=d2a66fc564ec399b02919be1792e420d&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F8326cffc1e178a82c4403d44f803738da877e8d2.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          /// 默认加载
          new Offstage(
            offstage: !(_status == 0),
            child: Image.asset(
              Utils.getImgPath("splash/start_page", format: "jpg"),
              width: double.infinity,
              fit: BoxFit.fill,
              height: double.infinity,
            ),
          ),

          /// 轮播
          Offstage(
            offstage: !(_status == 2),
            child: Swiper(
              itemCount: _guideList.length,
              loop: false,
              itemBuilder: (_, index) {
                return loadAssetImage(
                  _guideList[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
              onTap: (index) {
                if (index == _guideList.length - 1) {
                  _goMain();
                }
              },
            ),
          ),

          /// 广告
          new Offstage(
            offstage: !(_status == 1  ),
            child: Stack(
              children: <Widget>[
                new InkWell(
                  onTap: () {},
                  child: loadNetworkImage(
                    _splashModel.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    holderImg: 'splash/splash_bg',
                  ),
                ),
                Container(
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
                        border: new Border.all(width: 0.33),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerUtil != null) _timerUtil.cancel(); //记得中dispose里面把timer cancel。
  }

  void _initAsync() async {

    await SpUtil.getInstance();
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

  //
  void _getHomeCateList() {
    HttpUtil()
        .get('homeCateList')
        .then((val) {
      if (val["success"]) {
        setState(() {
          List<HomeCateEntity> homeCateList = EntityListFactory.generateList<HomeCateEntity>(val['data']);
          print(homeCateList.length);
          SpUtil.putObjectList('homeCateList', homeCateList);


        });
      }
    });
  }

  /// 初始化 引导页
  void _initBanner() {
    setState(() {
      _status = 2;
    });
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
    NavigatorUtil.push(context, Routers.root, replace: true);
  }
}
