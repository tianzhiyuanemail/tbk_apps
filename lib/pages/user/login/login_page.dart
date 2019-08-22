import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tbk_app/common/common.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/res/resources.dart';
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

/// 用户登录
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  KeyboardActionsConfig _config;
  bool _isClick = false;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _nameController.text = SpUtil.getString(Constant.phone);
    _config = Utils.getKeyboardActionsConfig([_nodeText1, _nodeText2]);
  }

  void _verify() {
    String name = _nameController.text;
    String password = _passwordController.text;
    bool isClick = true;
    if (name.isEmpty || name.length < 11) {
      isClick = false;
    }
    if (password.isEmpty || password.length < 6) {
      isClick = false;
    }

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }

  void _login() {

    Toast.show("确认......");
    String name = _nameController.text;
    String password = _passwordController.text;


    Map<String, Object> map = Map();
    map["loginType"] = 4;
    map["mobile"] = name;
    map["password"] = password;

    HttpUtil()
        .get('loginPassword', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          isBack: true,
          actionName: '验证码登录',
          onPressed: () {
            NavigatorUtil.push(context, Routers.smsLoginPage);
          },
        ),
        body: defaultTargetPlatform == TargetPlatform.iOS
            ? FormKeyboardActions(
                child: _buildBody(),
              )
            : SingleChildScrollView(
                child: _buildBody(),
              ));
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "密码登录",
            style: TextStyles.textBoldDark26,
          ),
          Gaps.vGap16,
          MyTextField(
            focusNode: _nodeText1,
            controller: _nameController,
            maxLength: 11,
            keyboardType: TextInputType.phone,
            hintText: "请输入账号",
          ),
          Gaps.vGap10,
          MyTextField(
            focusNode: _nodeText2,
            config: _config,
            isInputPwd: true,
            controller: _passwordController,
            maxLength: 16,
            hintText: "请输入密码",
          ),
          Gaps.vGap10,
          Gaps.vGap15,
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
              onTap: () {
                NavigatorUtil.push(context, Routers.resetPasswordPage);
              },
            ),
          ),
          Gaps.vGap16,
          Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: Text(
                  '还没账号？快去注册',
                  style: TextStyle(color: Colours.text_blue),
                ),
                onTap: () {
                  NavigatorUtil.push(context, Routers.registerPage);
                },
              ))
        ],
      ),
    );
  }
}
