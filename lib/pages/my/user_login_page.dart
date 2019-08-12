import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/sms_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/shared_preference_util.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:nautilus/nautilus.dart' as nautilus;

import '../../entity_factory.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  ///利用FocusNode和FocusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的FocusScopeNode

  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusScopeNode focusScopeNode = FocusScopeNode();
  GlobalKey<FormState> _signInFormKey = GlobalKey();
  String code = '获取验证码';
  String phoneNumber = '';
  String _password = '获取验证码';

  TimerUtil _timerUtil;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
          title: Container(
            margin: EdgeInsets.only(top: 5),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              NavigatorUtil.gotransitionPop(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.02),
      ),
      /**
       * SafeArea，让内容显示在安全的可见区域
       * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
       */
      body: SafeArea(
        child: SingleChildScrollView(
          /**
           * 用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
           */
          child: Container(
            /**这里要手动设置container的高度和宽度，不然显示不了
             * 利用MediaQuery可以获取到跟屏幕信息有关的数据
             */
            margin: EdgeInsets.only(top: 100),
            height: ScreenUtil().setHeight(1334),
            width: ScreenUtil().setWidth(750),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset("assets/images/sys/bootstarp.png",
                      width: 100.0, height: 100.0),
                ),
                //顶部图片
                Container(
                  padding: EdgeInsets.only(top: 23),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          //创建表单
                          this.buildSignInTextForm(),
                          this._xieyi(),
                          this.buildSignInButton(),
                          this._otherLogin(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: Colors.white,
      ),
      width: 300,
      height: 160,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: Form(
        key: _signInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: TextFormField(
                  //关联焦点
                  focusNode: phoneFocusNode,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },
                  keyboardAppearance: Brightness.light,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.black45,
                      ),
                      hintText: "手机号",
                      border: InputBorder.none),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                  onSaved: (val) {
                    phoneNumber = val;
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 20),
                    child: TextFormField(
                      focusNode: passwordFocusNode,
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.beenhere,
                          color: Colors.black45,
                        ),
                        hintText: "验证码",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 0, top: 20),
                    child: RaisedButton(
                      onPressed: () {
                        getCode();
                      },
                      child: Text(code),
                      color: Colors.pink,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _xieyi() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "同意京淘优券协议",
        style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
            decoration: TextDecoration.underline),
      ),
    );
  }

  /// 创建登录界面的按钮
  Widget buildSignInButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: RaisedButton(
        child: Container(
          padding: EdgeInsets.only(left: 42, right: 42, top: 5, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            "登录",
            style: TextStyle(fontSize: 25, color: Colors.black45),
          ),
        ),
        onPressed: () {
          /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
          if (_signInFormKey.currentState.validate()) {
            //调用所有自孩子的save回调，保存表单内容
            _signInFormKey.currentState.save();
            _phoneLogin();
          }
        },
      ),
    );
  }

  Widget _otherLogin() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: InkWell(
              child: Image.asset("assets/images/taobao/taobao.png",
                  width: 50.0, height: 50.0),
              onTap: _taobaoLogin(),
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: InkWell(
              child: Image.asset("assets/images/taobao/tianmao.png",
                  width: 50.0, height: 50.0),
              onTap: _weixinLogin(),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取验证码
  void getCode() {
    if (code == "重新获取" || code == "获取验证码") {
      //调用所有自孩子的save回调，保存表单内容
      _signInFormKey.currentState.save();

      Map<String, Object> map = Map();
      map["type"] = 1;
      map["mobile"] = phoneNumber;

      HttpUtil()
          .get('sendSms', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
          .then((val) {
        if (val["success"]) {
          SmsEntity smsEntity =
              EntityFactory.generateOBJ<SmsEntity>(val['data']);

          if (smsEntity.code == 'OK') {
            _timerUtil = TimerUtil(mTotalTime: 60 * 1000);
            _timerUtil.setOnTimerTickCallback((int tick) {
              double _tick = tick / 1000;
              setState(() {
                code = _tick.toInt().toString();
              });
              if (_tick == 0) {
                setState(() {
                  code = "重新获取";
                });
              }
            });
            _timerUtil.startCountDown();
          }
        }
      });
    }
  }

  void _phoneLogin() {
    Map<String, Object> map = Map();
    map["loginType"] = 4;
    map["mobile"] = phoneNumber;
    map["code"] = _password;

    HttpUtil()
        .get('registerOrLogin',
        parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        UserInfoEntity userInfoEntityr =
        EntityFactory.generateOBJ<UserInfoEntity>(val['data']);

        SpUtil.putString("tocken", userInfoEntityr.tocken);
        NavigatorUtil.gotransitionPage(context, "${Routers.root}");
      }
    });
  }

  _taobaoLogin() async {
    var result = await nautilus.login();
    print(result.toString());
  }

  _weixinLogin() {}
}
