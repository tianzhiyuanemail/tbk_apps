import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'router_handler.dart';

class Routers {
  static String root = '/';
  static String detailsPage = '/detail';
  static String searchPage = '/searchPagee';
  static String catePage = '/catePage';
  static String brandPage = '/brandPage';

  static String searchProductListPage = '/searchProductListPage';
  static String productListPage = '/productListPage';

  static String navigatorRouterPage = '/navigatorRouterPage';
  static String navigatorWebViewPage = '/navigatorWebViewPage';

  static String myPage = '/myPage';


  static String userLoginPage = '/userLoginPage';
  static String userLoginPageBangDing = '/userLoginPageBangDing';


  static String weiTaoPage = "/weiTaoPage";



  static String loginPage = "/login";
  static String registerPage = "/login/register";
  static String smsLoginPage = "/login/smsLogin";
  static String resetPasswordPage = "/login/resetPassword";
  static String updatePasswordPage = "/login/updatePassword";


  static String updateNamePage = "/user/updateNamePage";
  static String updateTagPage = "/user/updateTagPage";
  static String userSecurityPage = "/user/userSecurityPage";

  static String accountPage = "/account";
  static String accountRecordListPage = "/account/recordList";
  static String addWithdrawalAccountPage = "/account/addWithdrawal";
  static String bankSelectPage = "/account/bankSelect";
  static String citySelectPage = "/account/citySelect";
  static String withdrawalAccountListPage = "/account/withdrawalAccountList";
  static String withdrawalAccountPage = "/account/withdrawalAccount";
  static String withdrawalPage = "/account/withdrawal";
  static String withdrawalPasswordPage = "/account/withdrawalPassword";
  static String withdrawalRecordListPage = "/account/withdrawalRecordList";
  static String withdrawalResultPage = "/account/withdrawalResult";


  static String messagePage = "/messagePage";


  static String settingPage = "/setting";
  static String aboutPage = "/setting/about";
  static String accountManagerPage = "/setting/accountManager";



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
    router.define(catePage, handler: catePageHandler);
    router.define(brandPage, handler: brandPageHandler);

    router.define(searchProductListPage, handler: searchProductListPageHandler);
    router.define(productListPage, handler: productListPageHandler);

    router.define(navigatorRouterPage, handler: navigatorRouterPageHandler);
    router.define(navigatorWebViewPage, handler: navigatorWebViewPageHandler);

    router.define(myPage, handler: myPageHandler);
    router.define(userLoginPage, handler: userLoginPageHandler);
    router.define(userLoginPageBangDing, handler: userLoginPageBangDingHandler);


    router.define(weiTaoPage, handler:weiTaoPageHandler);



    router.define(loginPage, handler:loginPageHandler);
    router.define(registerPage, handler: registerPageHandler);
    router.define(smsLoginPage, handler: smsLoginPageHandler);
    router.define(resetPasswordPage, handler: resetPasswordPageHandler);
    router.define(updatePasswordPage, handler: updatePasswordPageHandler);
    router.define(updateNamePage, handler: updateNamePageHandler);
    router.define(updateTagPage, handler: updateTagPageHandler);
    router.define(userSecurityPage, handler: userSecurityPageHandler);

    router.define(accountPage, handler: accountPageHandler);
    router.define(accountRecordListPage, handler: accountRecordListPageHandler);
    router.define(addWithdrawalAccountPage, handler: addWithdrawalAccountPageHandler);
    router.define(bankSelectPage, handler: bankSelectPageHandler);
    router.define(citySelectPage, handler: citySelectPageHandler);
    router.define(withdrawalAccountListPage, handler: withdrawalAccountListPageHandler);
    router.define(withdrawalAccountPage, handler: withdrawalAccountPageHandler);
    router.define(withdrawalPage, handler: withdrawalPageHandler);
    router.define(withdrawalPasswordPage, handler: withdrawalPasswordPageHandler);
    router.define(withdrawalRecordListPage, handler: withdrawalRecordListPageHandler);
    router.define(withdrawalResultPage, handler: withdrawalResultPageHandler);



    router.define(messagePage, handler: messagePageHandler);

    router.define(settingPage, handler: settingPageHandler);
    router.define(aboutPage, handler: aboutPageHandler);
    router.define(accountManagerPage, handler: accountManagerPageHandler);





    router.define(root, handler: rootHandler);
  }

}





