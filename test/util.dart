import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Util   {

  static setKeyboardActions (BuildContext context,List<FocusNode> list){
    FormKeyboardActions.setKeyboardActions(context, KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: List.generate(list.length, (i) => KeyboardAction(
        focusNode: list[i],
        closeWidget: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text("关闭"),
        ),
      )),

    ));
  }
}
