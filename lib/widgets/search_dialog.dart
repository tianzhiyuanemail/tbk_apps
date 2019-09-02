import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/util/utils.dart';
import 'package:tbk_app/util/version_utils.dart';

class SearchDialog extends StatefulWidget {
  String searchText;

  SearchDialog(this.searchText);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// 使用false禁止返回键返回，达到强制升级目的
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 280.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        height: 140.0,
                        width: 280.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(8.0)),
                          image: DecorationImage(
                            image: AssetImage(Utils.getImgPath(
                                "sys/update_head",
                                format: 'jpg')),
                            fit: BoxFit.cover,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child:
                          Text(widget.searchText, style: TextStyles.textDark14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 110.0,
                            height: 36.0,
                            child: FlatButton(
                              onPressed: () {
                                NavigatorUtil.goBack(context);
                              },
                              textColor: Colours.app_main,
                              color: Colors.transparent,
                              disabledTextColor: Colors.white,
                              disabledColor: Colours.text_gray_c,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colours.app_main,
                                    width: 0.8,
                                  )),
                              child: Text(
                                "取消",
                                style: TextStyle(fontSize: Dimens.font_sp16),
                              ),
                            ),
                          ),
                          Container(
                            width: 110.0,
                            height: 36.0,
                            child: FlatButton(
                              onPressed: () {
                                NavigatorUtil.goBack(context);
                                NavigatorUtil.push(
                                    context,
                                    Routers.searchProductListPage +
                                        "?searchText=" +
                                        FluroConvertUtils.fluroCnParamsEncode(
                                            widget.searchText));
                              },
                              textColor: Colors.white,
                              color: Colours.app_main,
                              disabledTextColor: Colors.white,
                              disabledColor: Colours.text_gray_c,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text(
                                "搜索",
                                style: TextStyle(fontSize: Dimens.font_sp16),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
