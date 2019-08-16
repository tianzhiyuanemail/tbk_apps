import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tbk_app/res/styles.dart';
import 'package:tbk_app/util/image_utils.dart';

// ignore: must_be_immutable
class ImageTextClickItem extends StatelessWidget {
  String image;
  String title;
  Function onTap;

  ImageTextClickItem(this.image, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Container(
              child: loadAssetImage(image, width: 30.0, height: 30.0),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(
                title,
                style: TextStyles.textNormal12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CateItem extends StatelessWidget {

  String image;
  String title;
  Function onTap;
  CateItem({Key key,this.image, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0,bottom: 0,left: 5,right: 5),
              child: loadNetworkImage(image,width: 60,height: 60),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 0,bottom: 0,left: 5,right: 5),
              child: Text(title),
            )
          ],
        ),
      ),
    );
  }
}
