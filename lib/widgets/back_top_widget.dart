import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackTopButton extends StatelessWidget {
  ScrollController controller;

  bool showToTopBtn; //是否显示“返回到顶部”按钮

  BackTopButton({Key key, this.controller, this.showToTopBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !showToTopBtn,
      child: FloatingActionButton(
          heroTag: null,
          /// 解决错误 There are multiple heroes that share the same tag within a subtree.
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
            size: 20,
          ),
          tooltip: "按这么长时间干嘛",
          mini: true,
          elevation: 7.0,
          highlightElevation: 14.0,
          onPressed: () {
            //返回到顶部时执行动画
            controller.animateTo(.0,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          }
      ),


    );
  }
}
