import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tbk_app/constant/constant.dart';

import '../container_page.dart';

///打开APP首页
class SplashWidget extends StatefulWidget {
  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  bool showAd = true;


  @override
  Widget build(BuildContext context) {


    return Stack(
      children: <Widget>[
        Offstage( /// 主程序
          offstage: showAd,
          child:  ContainerPage(),
        ),
        Offstage( /// 欢迎页面
          offstage: !showAd,
          child:  InkWell( /// 设置背景图片点击事件
            onTap: ()=>print("222222222222222222"),
            child: Container( ///  内容
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Constant.ASSETS_IMG + 'shouye.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                  children: <Widget>[
                  SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                          Align(
                            alignment: Alignment(1.0, 0.0),
                            child: Container(
                              margin: const EdgeInsets.only(right: 30.0, top: 20.0),
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0))
                              ),
                              child: CountDownWidget(
                                onCountDownFinishCallBack: (bool value) {
                                  if (value) {
                                    setState(() {
                                      showAd = false;
                                    });
                                  }
                                },
                              ),

                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: new Text(
                                "你好,世界！！！！",
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  Constant.ASSETS_IMG + 'ic_launcher.png',
                                  width: 50.0,
                                  height: 50.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Hi,豆芽',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ) /// SafeArea
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

}


class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;

  CountDownWidget({Key key, @required this.onCountDownFinishCallBack}) : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  var _seconds = 1;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(fontSize: 17.0),
    );
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      if (_seconds <= 1) {
        widget.onCountDownFinishCallBack(true);
        _cancelTimer();
        return;
      }
      _seconds--;
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }
}
