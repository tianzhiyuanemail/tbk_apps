import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'router_handler.dart';

class Routers {
  static String root = '/';
  static String detailsPage = '/detail';
  static String searchPage = '/searchPagee';

  static String searchProductListPage = '/searchProductListPage';
  static String productListPage = '/productListPage';

  static String navigatorRouterPage = '/navigatorRouterPage';
  static String navigatorWebViewPage = '/navigatorWebViewPage';

  static String userSetUpPage = '/userSetUpPage';
  static String userLoginPage = '/userLoginPage';

  static void configureRouters(Router router){

    /// 配置默认路由
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print("没有路由");
      }
    );


    /// 配置路由
    router.define(detailsPage, handler: detailsHandler);
    router.define(searchPage, handler: searchPageHandler);

    router.define(searchProductListPage, handler: searchProductListPageHandler);
    router.define(productListPage, handler: productListPageHandler);

    router.define(navigatorRouterPage, handler: navigatorRouterPageHandler);
    router.define(navigatorWebViewPage, handler: navigatorWebViewPageHandler);

    router.define(userSetUpPage, handler: userSetUpPageHandler);
    router.define(userLoginPage, handler: userLoginPageHandler);

    router.define(root, handler: rootHandler);
  }

}





