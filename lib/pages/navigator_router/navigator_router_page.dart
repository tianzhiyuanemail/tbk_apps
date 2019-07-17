import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/util/colors_util.dart';

class NavigatorRouterPage extends StatefulWidget {

  String url;
  String title;


  NavigatorRouterPage(this.url,this.title);

  @override
  _nineParcelPostState createState() => _nineParcelPostState();
}

// ignore: camel_case_types
class _nineParcelPostState extends State<NavigatorRouterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
          title: Text(widget.title),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.screenHeight*0.03),
      ),
      body: Container(
        child: Text(widget.url),
      ),
    );
  }
}
