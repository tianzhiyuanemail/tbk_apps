import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/pages/container_page.dart';
import 'package:tbk_app/pages/navigator_router/navigator_router_page.dart';
import 'package:tbk_app/pages/product/product_list_page.dart';
import 'package:tbk_app/pages/search/search_product_list_page.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/widgets/web_view_page_widget.dart';

import '../pages/product/product_deatil_page.dart';
import '../pages/search/search_page.dart';

/// details
Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String productId = params['id'].first;
      print("路由的ID" + productId);
      return ProductDetail(productId);
    }
);

/// searchPage
Handler searchPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SearchPage();
    }
);

///searchProductList
Handler searchProductListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String searchText = params['searchText'].first;
      return SearchProductListPage(searchText);
    }
);

///productListPage
Handler productListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String cateId = params['cateId'].first;
      String s = params['cateName'].first;
      String cateName = FluroConvertUtils.fluroCnParamsDecode(s);
      return ProductListPage(cateId,cateName);
    }
);

/// navigatorRouterPage
Handler navigatorRouterPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String url = params['url'].first;
      String s = params['title'].first;
      String title = FluroConvertUtils.fluroCnParamsDecode(s);

      return NavigatorRouterPage(url,title);
    }
);
/// NavigatorWebViewPage
Handler navigatorWebViewPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String u = params['url'].first;
      String s = params['title'].first;
      String url = Uri.decodeComponent(u);
      String title = FluroConvertUtils.fluroCnParamsDecode(s);

      return WebViewPageWidget(url,title);
    }
);

/// root
Handler rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ContainerPage();
    }
);
