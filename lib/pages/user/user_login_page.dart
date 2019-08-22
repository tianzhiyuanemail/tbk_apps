import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/sms_entity.dart';
import 'package:tbk_app/modle/taobao_user_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
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
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              "登录",
              style: TextStyle(color: Colors.black45),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black45,
              size: 20,
            ),
            onPressed: () {
              NavigatorUtil.goBack(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.02),
      ),
      resizeToAvoidBottomInset: false,
      /**
       * SafeArea，让内容显示在安全的可见区域
       * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
       */
      body: Stack(
        children: <Widget>[
          Container(
            /**这里要手动设置container的高度和宽度，不然显示不了
             * 利用MediaQuery可以获取到跟屏幕信息有关的数据
             */
            height: ScreenUtil().setHeight(1300),
            width: ScreenUtil().setWidth(750),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/user/login.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              onTap: () {
                passwordFocusNode.unfocus();
                phoneFocusNode.unfocus();
                print("2342");
              },
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 60),
              child: Column(
                children: <Widget>[
                  this._buildLogle(),
                  this._buildSignInTextForm(),
                  this._buildSignInButton(),
                  this._buildText("登录即表示同意用户协议"),
                  this._otherLogin(),
                  this._buildText2("其他登录方式"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogle() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Image.asset("assets/images/sys/bootstarp.png",
          width: 100.0, height: 100.0),
    );
  }

  /// 创建登录界面的TextForm
  Widget _buildSignInTextForm() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 300,
      height: 150,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// 手机号
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white.withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 0, bottom: 0),
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
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),

                  onSaved: (val) {
                    phoneNumber = val;
                  },
                ),
              ),
            ),

            /// 验证码
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white.withOpacity(0.5),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(
                        left: 25, right: 0, top: 0, bottom: 0),
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
                        fontSize: 20,
                        color: Colors.red,
                      ),
                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 0, top: 0),
                    child: RaisedButton(
                      onPressed: () {
                        getCode();
                      },
                      child: Text(code),
                      color: Colors.pink,
                      textColor: Colors.white,
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

  Widget _buildText(str) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        str,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildText2(str) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        str,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    );
  }

  /// 创建登录界面的按钮
  Widget _buildSignInButton() {
    return Container(
      width: 290,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: RaisedButton(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            "登    录",
            style: TextStyle(fontSize: 23, color: Colors.white),
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
      margin: EdgeInsets.only(top: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color: Colors.white,
//            ),
            child: InkWell(
              child: Image.asset("assets/images/taobao/taobao.png",
                  width: 50.0, height: 50.0),
              onTap: () {
                _taobaoLogin();
              },
            ),
          ),
          SizedBox(
            width: 40,
          ),
          Container(
            child: InkWell(
              child: Image.asset("assets/images/taobao/tianmao.png",
                  width: 50.0, height: 50.0),
              onTap: () {
                _weixinLogin();
              },
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
        .get('registerOrLogin', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        UserInfoEntity userInfoEntityr =
            EntityFactory.generateOBJ<UserInfoEntity>(val['data']);

        SpUtil.putString("tocken", userInfoEntityr.tocken);
        NavigatorUtil.gotransitionPage(context, "${Routers.root}");
      }
    });
  }

  void _taobaoLogin() {
    nautilus.login().then((data) {
      setState(() {
        if (data.isSuccessful) {
          print(data.user.nick);

          TaobaoUserEntity t = new TaobaoUserEntity();
          t.avatarUrl = data.user.avatarUrl;
          t.nick = data.user.nick;
          t.openId = data.user.openId;
          t.openSid = data.user.openSid;
          t.topAccessToken = data.user.topAccessToken;
          t.topAuthCode = data.user.topAuthCode;

          NavigatorUtil.gotransitionPage(
              context,
              Routers.userLoginPageBangDing +
                  "?json=" +
                  FluroConvertUtils.object2string(t));
        } else {}
      });
    });
  }

  void _weixinLogin() {}
}
