import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/modle/material_entity.dart';
import 'package:tbk_app/modle/taobao_user_entity.dart';
import 'package:tbk_app/pages/container_page.dart';
import 'package:tbk_app/pages/user/fund/account_record_list_page.dart';
import 'package:tbk_app/pages/user/fund/add_withdrawal_account_page.dart';
import 'package:tbk_app/pages/user/fund/bank_select_page.dart';
import 'package:tbk_app/pages/user/fund/city_select_page.dart';
import 'package:tbk_app/pages/user/fund/account_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_account_list_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_account_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_password_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_record_list_page.dart';
import 'package:tbk_app/pages/user/fund/withdrawal_result_page.dart';
import 'package:tbk_app/pages/user/message/message_page.dart';
import 'package:tbk_app/pages/user/setting/about_page.dart';
import 'package:tbk_app/pages/user/setting/account_manager_page.dart';
import 'package:tbk_app/pages/user/setting/setting_page.dart';
import 'package:tbk_app/pages/user/setting/update_name_page.dart';
import 'package:tbk_app/pages/user/setting/update_tag_page.dart';
import 'package:tbk_app/pages/user/setting/user_security_page.dart';
import 'package:tbk_app/pages/user/user_login_bangding_page.dart';
import 'package:tbk_app/pages/user/user_login_page.dart';
import 'package:tbk_app/pages/navigator_router/navigator_router_page.dart';
import 'package:tbk_app/pages/product/product_list_page.dart';
import 'package:tbk_app/pages/search/search_product_list_page.dart';
import 'package:tbk_app/pages/user/login/login_page.dart';
import 'package:tbk_app/pages/user/login/register_page.dart';
import 'package:tbk_app/pages/user/login/reset_password_page.dart';
import 'package:tbk_app/pages/user/login/sms_login_page.dart';
import 'package:tbk_app/pages/user/login/update_password_page.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/widgets/web_view_page_widget.dart';

import '../entity_factory.dart';
import '../pages/product/product_deatil_page.dart';
import '../pages/search/search_page.dart';
import 'dart:convert';

/// details
Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String productId = params['id'].first;
  print("路由的ID" + productId);
  return ProductDetail(productId);
});

/// searchPage
Handler searchPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SearchPage();
});

///searchProductList
Handler searchProductListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String s = params['searchText'].first;
  String searchText = FluroConvertUtils.fluroCnParamsDecode(s);
  return SearchProductListPage(searchText);
});

///productListPage
Handler productListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String cateId = params['cateId'].first;
  String s = params['cateName'].first;
  String cateName = FluroConvertUtils.fluroCnParamsDecode(s);
  return ProductListPage(cateId, cateName);
});

/// navigatorRouterPage
Handler navigatorRouterPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = params['url'].first;
  String s = params['title'].first;
  String j = params['json'].first;
  String title = FluroConvertUtils.fluroCnParamsDecode(s);
  List<Materialentity> materialentityList =
      FluroConvertUtils.string2List<Materialentity>(j);
  return NavigatorRouterPage(url, title, materialentityList);
});

/// NavigatorWebViewPage
Handler navigatorWebViewPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String u = params['url'].first;
  String s = params['title'].first;
  String url = Uri.decodeComponent(u);
  String title = FluroConvertUtils.fluroCnParamsDecode(s);

  return WebViewPageWidget(url, title);
});



/// UserLoginPage
Handler userLoginPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserLoginPage();
});

/// userLoginPageBangDing
Handler userLoginPageBangDingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String j = params['json'].first;
  Map<String, dynamic> map = FluroConvertUtils.string2map(j);
  TaobaoUserEntity taobaoUserEntity =
      EntityFactory.generateOBJ<TaobaoUserEntity>(map);
  return UserLoginBangDingPage(taobaoUserEntity);
});

/// login start
Handler loginPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});
Handler registerPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RegisterPage();
});
Handler resetPasswordPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ResetPasswordPage();
});
Handler smsLoginPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SMSLoginPage();
});

Handler updatePasswordPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UpdatePasswordPage();
});

Handler updateNamePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UpdateNamePage();
});

Handler updateTagPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UpdateTagPage();
});

Handler userSecurityPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserSecurityPage();
});

/// fund
Handler accountPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AccountPage();
});

Handler accountRecordListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AccountRecordListPage();
});

Handler addWithdrawalAccountPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddWithdrawalAccountPage();
});

Handler bankSelectPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BankSelectPage();
});

Handler citySelectPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CitySelectPage();
});

Handler withdrawalAccountListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalAccountListPage();
});

Handler withdrawalAccountPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalAccountPage();
});

Handler withdrawalPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalPage();
});

Handler withdrawalPasswordPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalPasswordPage();
});

Handler withdrawalRecordListPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalRecordListPage();
});

Handler withdrawalResultPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return WithdrawalResultPage();
});



/// fund






/// login end
Handler messagePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MessagePage();
});

/// setting

Handler settingPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SettingPage();
});
Handler aboutPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AboutPage();
});
Handler accountManagerPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AccountManagerPage();
});

/// setting

/// root
Handler rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ContainerPage();
});
