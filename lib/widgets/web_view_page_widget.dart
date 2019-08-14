import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';

// ignore: must_be_immutable
class WebViewPageWidget extends StatefulWidget {
  String url;
  String title;

  WebViewPageWidget(this.url,this.title);

  @override
  _WebViewPageWidgetState createState() => _WebViewPageWidgetState();
}

class _WebViewPageWidgetState extends State<WebViewPageWidget> {
  // 标记是否是加载中
  bool loading = true;

  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  // URL变化监听器
  StreamSubscription<String> onUrlChanged;

  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> onStateChanged;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {

    onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
          // 开始加载
          break;
        case WebViewState.finishLoad:
          // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据
            parseResult();
          }
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
  }

  void reload(){
    flutterWebViewPlugin.reload();
  }

  // 解析WebView中的数据
  void parseResult() {
//    flutterWebViewPlugin.evalJavascript("get();").then((result) {
//      // result json字符串，包含token信息
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = new List();
    titleContent.add(new Container());
    titleContent.add(Container(
      margin: EdgeInsets.only(right: 20),
      child: new Text(
        widget.title,
        style: new TextStyle(color: Colors.white,fontSize: 15),
      ),
    ));
    if (loading) {
      // 如果还在加载中，就在标题栏上显示一个圆形进度条
      titleContent.add(Container(
        width: 32,
        child: CupertinoActivityIndicator(),
      ));
    } else {
      titleContent.add(
        Container(
          width: 32,
          child: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              reload();
            },
            color: Colors.white,
            iconSize: 20,
          ),
        ),
      );
    }

    // WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL
    return new WebviewScaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: titleContent,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              NavigatorUtil.goBack(context);
            },
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight * 0.025),
      ),
      key: scaffoldKey,
      // 登录的URL
      url: widget.url,
      // 登录的URL

      withZoom: true,
      // 允许网页缩放
      withLocalStorage: true,
      // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    onUrlChanged.cancel();
    onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}
