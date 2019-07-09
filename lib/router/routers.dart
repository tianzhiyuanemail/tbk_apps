import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'router_handler.dart';

class Routers {
  static String root = '/';
  static String detailsPage = '/detail';

  static void configureRouters(Router router){

    /// 配置默认路由
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print("没有路由");
      }
    );
    /// 配置路由
      router.define(detailsPage, handler: detailsHandler);
      router.define(root, handler: rootHandler);

  }

}





