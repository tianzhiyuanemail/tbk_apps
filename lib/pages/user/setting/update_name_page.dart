
import 'package:flutter/material.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/toast.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/my_button.dart';
import 'package:tbk_app/widgets/text_field.dart';

/// 修改密码
class UpdateNamePage extends StatefulWidget {
  @override
  _UpdateNamePageState createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends State<UpdateNamePage> {
  //定义一个controller
  TextEditingController _controller = TextEditingController();
  bool _isClick = false;
  
  @override
  void initState() {
    super.initState();
    //监听输入改变  
    _controller.addListener(_verify);
  }

  void _verify(){
    String text = _controller.text;
    bool isClick = true;
    if (text.isEmpty || text.length < 1) {
      isClick = false;
    }

    if (isClick != _isClick){
      setState(() {
        _isClick = isClick;
      });
    }
  }
  
  void _confirm(){
    Toast.show("修改成功！");
    NavigatorUtil.goBack(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "修改昵称",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Gaps.vGap16,
            Gaps.vGap16,
            Gaps.vGap10,
            MyTextField(
              controller: _controller,
              maxLength: 16,
              hintText: "请输入新昵称",
            ),
            Gaps.vGap10,
            Gaps.vGap15,
            MyButton(
              onPressed: _isClick ? _confirm : null,
              text: "确认",
            )
          ],
        ),
      ),
    );
  }
}
