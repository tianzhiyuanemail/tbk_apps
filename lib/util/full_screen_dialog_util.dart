import 'package:flutter/material.dart';

class FullScreenDialogUtil {
  static void openFullDialog(BuildContext context, Widget widget,
      {bool replace = false, bool fullscreenDialog = true}) {
    if (replace) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return widget;
        },
        fullscreenDialog: fullscreenDialog,
      ));
    } else {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return widget;
        },
        fullscreenDialog: fullscreenDialog,
      ));
    }
  }

  static void closeFullDialog(BuildContext context) {
    Navigator.of(context).maybePop();
  }
}
