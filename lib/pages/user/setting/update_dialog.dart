
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/util/utils.dart';
import 'package:tbk_app/util/version_utils.dart';


class UpdateDialog extends StatefulWidget {
  
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  
  CancelToken _cancelToken = CancelToken();
  bool _isDownload = false;
  double _value = 0;
  
  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1){
      _cancelToken.cancel();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
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
                    borderRadius: const BorderRadius.only(topLeft: const Radius.circular(8.0), topRight: const Radius.circular(8.0)),
                    image: DecorationImage(
                      image: AssetImage(Utils.getImgPath("sys/update_head",format: 'jpg')),
                      fit: BoxFit.cover,
                    ),
                  )
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: const Text("新版本更新", style: TextStyles.textDark16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Text("1.又双叒修复了一大推bug。\n\n2.祭天了多名程序猿。", style: TextStyles.textDark14),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0 , top: 5.0),
                  child: _isDownload ? LinearProgressIndicator(
                    backgroundColor: Colours.line,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colours.app_main),
                    value: _value,
                  ): Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 110.0,
                        height: 36.0,
                        child: FlatButton(
                          onPressed: (){
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
                              )
                          ),
                          child: Text(
                            "残忍拒绝",
                            style: TextStyle(fontSize: Dimens.font_sp16),
                          ),
                        ),
                      ),
                      Container(
                        width: 110.0,
                        height: 36.0,
                        child: FlatButton(
                          onPressed: (){
                            if (defaultTargetPlatform == TargetPlatform.iOS){
                              NavigatorUtil.goBack(context);
                              VersionUtils.jumpAppStore();
                            }else{
                              setState(() {
                                _isDownload = true;
                              });
                              _download();
                            }
                          },
                          textColor: Colors.white,
                          color: Colours.app_main,
                          disabledTextColor: Colors.white,
                          disabledColor: Colours.text_gray_c,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            "立即更新",
                            style: TextStyle(fontSize: Dimens.font_sp16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        )
      ),
    );
  }
  
  ///下载apk
  _download() async {

  }
}
