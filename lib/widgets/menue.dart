import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/home_navigator_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';

class HomeMenueWidget extends StatelessWidget {
  final List<HomeNavigatorEntity> data;
  final String bgurl;
  final String fontColor;

  HomeMenueWidget({this.data, this.bgurl, this.fontColor});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    double height = ScreenUtil().setHeight(150);
    return Container(
      width: deviceWidth,
      height: height,
      child: _buildRow(context,deviceWidth),
      decoration: bgurl != ''
          ? BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(bgurl), fit: BoxFit.cover))
          : null,
    );
  }

  Row _buildRow(BuildContext context,double deviceWidth) {
    var colorInt = int.parse(fontColor.replaceAll('#', '0x'));
    Color color = new Color(colorInt).withOpacity(1.0);
    double iconWidth = ScreenUtil().setWidth(78);
    double iconHeight = ScreenUtil().setHeight(57);
    List<Widget> widgets = data.map((navigatorEntity) {
      return Expanded(
        child: InkWell(
          onTap: (){ if (navigatorEntity.isNative == 1) {
            NavigatorUtil.push(
                context,
                Routers.navigatorWebViewPage +
                    "?url=" +
                    Uri.encodeComponent(navigatorEntity.url) +
                    "&title=" +
                    FluroConvertUtils.fluroCnParamsEncode(navigatorEntity.title));
          } else if (navigatorEntity.isNative == 2) {
            NavigatorUtil.push(
                context,
                Routers.navigatorRouterPage +
                    "?url=" +
                    navigatorEntity.url +
                    "&title=" +
                    FluroConvertUtils.fluroCnParamsEncode(navigatorEntity.title) +
                    "&json=" +
                    FluroConvertUtils.object2string(
                        navigatorEntity.materialEntityList));
          }},
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                width: iconWidth,
                height: iconHeight,
                imageUrl: navigatorEntity.imageUrl,
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
              Text(
                navigatorEntity.title,
                style: TextStyle(
                    fontSize: 13.0,
                    height: 1.5,
                    decoration: TextDecoration.none,
                    color: color,
                ),
              )
            ],
          ),
        ),
      );
    }).toList();
    return Row(
      children: widgets,
    );
  }
}
