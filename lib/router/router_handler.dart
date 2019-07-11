import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/pages/container_page.dart';
import 'package:tbk_app/pages/home/home_page.dart';
import 'package:tbk_app/pages/search/search_product_list_page.dart';


import '../pages/product/product_deatil_page.dart';
import '../pages/search/search_page.dart';

Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String productId = params['id'].first;
      print("路由的ID" + productId);
      return ProductDetail(productId);
    }
);

Handler searchPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SearchPage();
    }
);
Handler searchProductListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String searchText = params['searchText'].first;
      print("路由的ID" + searchText);
      return SearchProductListPage(searchText);
    }
);

Handler rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ContainerPage();
    }
);
