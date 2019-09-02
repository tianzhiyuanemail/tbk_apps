import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/pages/user/login/login_page.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/util/sp_util.dart';

import 'full_screen_dialog_util.dart';

class NavigatorUtil {
  /// 跳转到 转场动画 页面 ， 这边只展示 inFromLeft ，剩下的自己去尝试下，
  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom

  static push(BuildContext context, String router,
      {bool replace = false, bool clearStack = false, bool isLogin = false}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    String tocken = SpUtil.getString("tocken");

    if (isLogin && tocken == null) {
      FullScreenDialogUtil.openFullDialog(context, LoginPage());
    } else {
      Application.router.navigateTo(context, router,
          replace: replace,
          clearStack: clearStack,
          transition: TransitionType.native);
    }
  }

  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Application.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transition: TransitionType.native)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      print("$error");
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pop(context, result);
  }
}
