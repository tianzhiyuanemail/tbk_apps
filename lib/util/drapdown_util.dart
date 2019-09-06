import 'package:flutter/material.dart';

class DrapDown extends StatelessWidget {
  double dropDownHeight;
  Animation<double> animation;
  Widget child;
  bool isShowMask;
  Function function;
  GlobalKey keyFilter;


  DrapDown({Key key,this.dropDownHeight, this.animation, this.child, this.isShowMask,
    this.function, this.keyFilter});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBoxRed;
    double top = 0;
    if (dropDownHeight != 0) {
      renderBoxRed = keyFilter.currentContext.findRenderObject();
      top = renderBoxRed.size.height;
    }
    return Positioned(
        width: MediaQuery.of(context).size.width,
        top: top,
        left: 0,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: animation == null ? 0 : animation.value,
              child: child,
            ),
            Offstage(
              // 这里是弹框后的空白区域
              offstage: !isShowMask,
              child: GestureDetector(
                onTap: function,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                ),
              ),
            )
          ],
        ));
  }
}
