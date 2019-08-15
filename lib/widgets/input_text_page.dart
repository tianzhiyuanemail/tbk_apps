
import 'package:flutter/material.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';

import 'app_bar.dart';

/// 路由返回参数
///
/***
 *    onTap: () {
        AppNavigator.pushResult(
        context,
        InputTextPage(
        title: "店铺简介",
        hintText: "这里有一段完美的简介…",
        content: _shopIntroduction,
        ),
        (result) {
        setState(() {
        _shopIntroduction = result.toString();
        });
        },
        );
    },
 *
 */
class InputTextPage extends StatefulWidget {

  InputTextPage({
    Key key,
    @required this.title,
    this.content,
    this.hintText,
    this.keyboardType: TextInputType.text,
  }) : super(key : key);

  final String title;
  final String content;
  final String hintText;
  final TextInputType keyboardType;
  
  @override
  _InputTextPageState createState() => _InputTextPageState();
}

class _InputTextPageState extends State<InputTextPage> {

  TextEditingController _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title,
        actionName: "完成",
        onPressed: (){
          NavigatorUtil.goBackWithParams(context, _controller.text);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: TextField(
          maxLength: 30,
          maxLines: 5,
          autofocus: true,
          controller: _controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            hintStyle: TextStyles.textGrayC14
          )
        ),
      ),
    );
  }
}
