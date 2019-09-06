import 'dart:async';

import 'package:flutter/material.dart';

import 'animation/diff_scale_text.dart';

/// 轮播头条
// ignore: must_be_immutable
class AnimationHeadlinesWidget extends StatefulWidget {
  List headlines;

  AnimationHeadlinesWidget({Key key, this.headlines});

  @override
  _AnimationHeadlinesWidgetState createState() =>
      _AnimationHeadlinesWidgetState();
}

class _AnimationHeadlinesWidgetState extends State<AnimationHeadlinesWidget> {
  int _diffScaleNext = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(
        width: 8,
      ),
      Text(
        '乐享头条',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 8,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          color: Color(0xFFfef2f2),
          child: Text(
            '精华',
            style: TextStyle(
              fontSize: 10,
              color: Colors.red[500],
            ),
          ),
        ),
      ),
      SizedBox(
        width: 8,
      ),
      Expanded(
          child: GestureDetector(
              onTap: () {},
              child: Container(
                child: DiffScaleText(
                  text: widget
                      .headlines[_diffScaleNext % widget.headlines.length],
                  textStyle: TextStyle(fontSize: 12, color: Colors.black),
                ),
                height: 30,
                alignment: Alignment.centerLeft,
              )))
    ]);
  }
}
