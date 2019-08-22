
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
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

/// 修改密码
class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _vCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  KeyboardActionsConfig _config;
  bool _isClick = false;
  
  @override
  void initState() {
    super.initState();
    //监听输入改变  
    _nameController.addListener(_verify);
    _vCodeController.addListener(_verify);
    _passwordController.addListener(_verify);
    _config = Utils.getKeyboardActionsConfig([_nodeText1, _nodeText2, _nodeText3]);
  }

  void _verify(){
    String name = _nameController.text;
    String vCode = _vCodeController.text;
    String password = _passwordController.text;
    bool isClick = true;
    if (name.isEmpty || name.length < 11) {
      isClick = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      isClick = false;
    }
    if (password.isEmpty || password.length < 6) {
      isClick = false;
    }
    if (isClick != _isClick){
      setState(() {
        _isClick = isClick;
      });
    }
  }

  void _reset(){
    Toast.show("确认......");
    String phoneNumber = _nameController.text;
    String vCode = _vCodeController.text;
    String password = _passwordController.text;


    Map<String, Object> map = Map();
    map["loginType"] = 4;
    map["mobile"] = phoneNumber;
    map["code"] = vCode;
    map["password"] = password;

    HttpUtil()
        .get('forgetPassword', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        Toast.show("修改成功");
        NavigatorUtil.goBack(context);
      }else{
        Toast.show("修改失败");
      }
    });

  }

  /// 获取验证码
  void _getCode() {
    String phoneNumber = _nameController.text;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "忘记密码",
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "重置登录密码",
            style: TextStyles.textBoldDark26,
          ),
          Gaps.vGap16,
          MyTextField(
            focusNode: _nodeText1,
            config: _config,
            controller: _nameController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "请输入手机号",
          ),
          Gaps.vGap10,
          MyTextField(
            focusNode: _nodeText2,
            controller: _vCodeController,
            keyboardType: TextInputType.number,
            getVCode: (){
              _getCode();
              return Future.value(true);
            },
            maxLength: 6,
            hintText: "请输入验证码",
          ),
          Gaps.vGap10,
          MyTextField(
            focusNode: _nodeText3,
            isInputPwd: true,
            controller: _passwordController,
            maxLength: 16,
            hintText: "请输入密码",
          ),
          Gaps.vGap10,
          Gaps.vGap15,
          MyButton(
            onPressed: _isClick ? _reset : null,
            text: "确认",
          )
        ],
      ),
    );
  }
}
