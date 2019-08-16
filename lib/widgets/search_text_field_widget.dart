import 'package:flutter/material.dart';
import 'package:tbk_app/util/image_utils.dart';

///文本搜索框
class SearchTextFieldWidget extends StatelessWidget {
  final VoidCallback onTab;

  SearchTextFieldWidget({
    Key key,
    this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        child: loadAssetImage('sys/search_text'),
      ),
    );
  }
}
