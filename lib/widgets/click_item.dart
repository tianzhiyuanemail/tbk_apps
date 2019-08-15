import 'package:flutter/material.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/util/image_utils.dart';

class ClickItem extends StatelessWidget {
  const ClickItem(
      {Key key,
      this.onTap,
      @required this.title,
      this.content: "",
      this.littleTitle: "",
      this.textAlign: TextAlign.start,
      this.style: TextStyles.textGray14,
      this.maxLines: 1,
      this.mtop: 0})
      : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String littleTitle;
  final String content;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;
  final double mtop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, top: mtop),
      padding: EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
      constraints: BoxConstraints(maxHeight: double.infinity, minHeight: 50.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: Divider.createBorderSide(context,
                color: Colours.line, width: 0.6),
          )),
      child: InkWell(
        onTap: onTap,
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: maxLines == 1
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyles.textDark14,
            ),
            Text(
              '         ${littleTitle}',
              style: TextStyles.textNormal12,
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                child: Text(
                  content,
                  maxLines: maxLines,
                  textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: style ?? TextStyles.textDark14,
                ),
              ),
            ),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                child: loadAssetImage(
                  "sys/ic_arrow_right",
                  height: 16.0,
                  width: 16.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
