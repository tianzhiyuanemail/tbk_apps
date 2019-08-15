
import 'package:flutter/material.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/widgets/base_dialog.dart';

class ExitDialog extends StatefulWidget{

  ExitDialog({
    Key key,
  }) : super(key : key);

  @override
  _ExitDialog createState() => _ExitDialog();
  
}

class _ExitDialog extends State<ExitDialog>{

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: "提示",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text("您确定要退出登录吗？", style: TextStyles.textDark16),
      ),
      onPressed: (){

        Navigator.of(context).pop('1');
        SpUtil.remove("tocken");
        NavigatorUtil.gotransitionPage(
            context, "${Routers.root}");
        NavigatorUtil.push(context,  Routers.loginPage, clearStack: true);
      },
    );
  }
}