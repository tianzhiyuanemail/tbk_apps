
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/util/utils.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/my_button.dart';
import 'package:tbk_app/widgets/text_field.dart';

import '../../../entity_factory.dart';

class SMSLoginPage extends StatefulWidget {
  @override
  _SMSLoginState createState() => _SMSLoginState();
}

class _SMSLoginState extends State<SMSLoginPage> {
  
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  KeyboardActionsConfig _config;
  bool _isClick = false;
  
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_verify);
    _vCodeController.addListener(_verify);
    _config = Utils.getKeyboardActionsConfig([_nodeText1, _nodeText2]);
  }

  void _verify(){
    String name = _phoneController.text;
    String vCode = _vCodeController.text;
    bool isClick = true;
    if (name.isEmpty || name.length < 11) {
      isClick = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      isClick = false;
    }
    if (isClick != _isClick){
      setState(() {
        _isClick = isClick;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: defaultTargetPlatform == TargetPlatform.iOS ? FormKeyboardActions(
        child: _buildBody(),
      ) : SingleChildScrollView(
        child: _buildBody(),
      )
    );
  }
  
  _buildBody(){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "验证码登录",
            style: TextStyles.textBoldDark26,
          ),
          Gaps.vGap16,
          MyTextField(
            focusNode: _nodeText1,
            config: _config,
            controller: _phoneController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "请输入手机号",
          ),
          Gaps.vGap10,
          MyTextField(
            focusNode: _nodeText2,
            controller: _vCodeController,
            maxLength: 6,
            keyboardType: TextInputType.number,
            hintText: "请输入验证码",
            getVCode: (){
              _getCode();
              return Future.value(true);
            },
          ),
          Gaps.vGap10,
          Container(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: '提示：未注册账号的手机号，请先',
                    style: TextStyles.textGray14,
                    children: <TextSpan>[
                      TextSpan(text: '注册', style: TextStyle(color: Colours.text_red)),
                      TextSpan(text: '。'),
                    ],
                  ),
                ),
                onTap: (){
                  NavigatorUtil.push(context, Routers.registerPage);
                },
              )
          ),
          Gaps.vGap15,
          Gaps.vGap10,
          MyButton(
            onPressed: _isClick ? _login : null,
            text: "登录",
          ),
          Container(
            height: 40.0,
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Text(
                '忘记密码',
                style: TextStyles.textGray12,
              ),
              onTap: (){
                NavigatorUtil.push(context, Routers.resetPasswordPage);
              },
            ),
          )
        ],
      ),
    );
  }

  void _login(){
    Toast.show("去登录......");
    Toast.show("确认......");
    String name = _phoneController.text;
    String code = _vCodeController.text;


    Map<String, Object> map = Map();
    map["loginType"] = 4;
    map["mobile"] = name;
    map["code"] = code;

    HttpUtil()
        .get('loginPhone', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        Toast.show("登录成功");
        UserInfoEntity userInfoEntityr =
        EntityFactory.generateOBJ<UserInfoEntity>(val['data']);

        SpUtil.putString("tocken", userInfoEntityr.tocken);
        NavigatorUtil.push(context, "${Routers.root}",);
      }else{
        Toast.show("登录失败");
      }
    });

  }
  /// 获取验证码
  void _getCode() {
    String phoneNumber = _phoneController.text;

    Map<String, Object> map = Map();
    map["type"] = 1;
    map["mobile"] = phoneNumber;

    HttpUtil()
        .get('sendSms', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        Toast.show("验证码已发送");
      }else{
        Toast.show("验证码发送失败");
      }
    });

  }
}
