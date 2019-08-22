import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nautilus/nautilus.dart' as nautilus;
import 'package:oktoast/oktoast.dart';
import 'package:provide/provide.dart';
import 'package:tbk_app/provide/child_cate.dart';
import 'package:tbk_app/provide/user_info_provide.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/loading.dart';
import 'pages/splash/splash_page.dart';

void main() async {
  var childCate = ChildCate();
  var userInfoProvide = UserInfoProvide();

  /// 初始化 状态
  var providers = Providers();
  providers
    ..provide(Provider<ChildCate>.value(childCate))
    ..provide(Provider<UserInfoProvide>.value(userInfoProvide));

  /// 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// 设置Android头部的导航栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style =
        new SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  nautilus.initTradeAsync(debuggable: false).then((data) {
    print("初始化淘宝客结果：${data.isSuccessful}");
  });

  await SpUtil.getInstance();
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// 初始化路由
    final router = Router();
    Routers.configureRouters(router);
    Application.router = router;

    print('home  $context');
//    print('home  ${Navigator.of(context)}');
    Loading.ctx = context; // 注入context

    return new RestartWidget(
      child: OKToast(
          //
          dismissOtherOnShow: true,
          // 这一步
          child: MaterialApp(
              onGenerateRoute: Application.router.generator,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                platform: TargetPlatform.iOS,
                backgroundColor: Colours.bg_color,
              ),
              home: Scaffold(
                resizeToAvoidBottomPadding: false,
                body: SplashPage(),
              ),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('zh', 'CH'),
                const Locale('en', 'US')
              ]),
          backgroundColor: Colors.black54,
          textPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          radius: 20.0,
          position: ToastPosition.bottom),
    );
  }
}

///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
