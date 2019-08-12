import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/router/application.dart';

class NavigatorUtil {
  /// 跳转到 转场动画 页面 ， 这边只展示 inFromLeft ，剩下的自己去尝试下，
  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
  static Future gotransitionPage(BuildContext context, String router) {
    return Application.router.navigateTo(
      context, router,
      /// 指定了 转场动画 fadeIn
      transition: TransitionType.native,
    );
  }


  /// 跳转到 转场动画 页面 ， 这边只展示 inFromLeft ，剩下的自己去尝试下，
  /// 框架自带的有 native，nativeModal，inFromLeft，inFromRight，inFromBottom，fadeIn，custom
  static Future gotransitionTransitionTypePage(BuildContext context, String router,TransitionType transition) {
    return Application.router.navigateTo(
      context, router,
      /// 指定了 转场动画 fadeIn
      transition: TransitionType.fadeIn,
    );
  }

  static void gotransitionPop(BuildContext context) {
     Application.router.pop(context,);
  }
}
