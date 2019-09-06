import 'package:flutter/material.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';


/// 历史记录 热门搜索
class SearchSuggestPage extends StatefulWidget {
  @override
  _SearchSuggestPageState createState() => _SearchSuggestPageState();
}

class _SearchSuggestPageState extends State<SearchSuggestPage> {
  bool _isHideSearchFind = false;
  List<String> searchRecordTexts = [
    'aoc4k显示器',
    'lg4k显示器',
    '菠萝',
    'iphone xs',
    '华为 p30',
    '三星 手机',
    'macbook pro 2018',
    '拓展坞',
    'dell xps15 9570',
  ];

  List<String> searchHintTexts = [
    '显示器4k',
    '显示器4k 144hz',
    '显示器4k 曲面',
    '电脑显示器4k',
    '显示器4k二手',
    '显示器27英寸4k',
    'aoc4k显示器',
    '显示器4k24寸',
    '43寸4k显示器',
    '4k显示器 曲面屏',
    'lg4k显示器',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          color: Colors.white),
//      color: Colors.red,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  '历史搜索',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 16,
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchRecordTexts
                .map((i) => GestureDetector(
                      onTap: () {
                        NavigatorUtil.push(context,
                            Routers.searchProductListPage + "?searchText=" +  FluroConvertUtils.fluroCnParamsEncode(i.toString()));

                      },
                      child: Container(
//                    height: 26,
//                          padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
                          decoration: BoxDecoration(
//                    color: randomColor(),
                              color: Color(0xFFf7f8f7),
                              borderRadius: BorderRadius.circular(13)),
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            i,
                            style: TextStyle(color: Color(0xFF565757), fontSize: 13),
                          )),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  '搜索发现',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isHideSearchFind = !_isHideSearchFind;
                  });
                },
                child: Icon(
                  _isHideSearchFind ? GZXIcons.attention_forbid : GZXIcons.attention_light,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Offstage(
            offstage: !_isHideSearchFind,
            child: Center(
              child: Text(
                '当前搜索发现已隐藏',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Offstage(
                offstage: _isHideSearchFind,
                child: GridView.count(
                  padding: const EdgeInsets.only(left: 12),
                  crossAxisCount: 2,
                  // 左右间隔
                  crossAxisSpacing: 8,
                  // 上下间隔
                  mainAxisSpacing: 8,
                  reverse: false,
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(
                    initialScrollOffset: 0.0,
                  ),
                  childAspectRatio: 12 / 2,
                  physics: BouncingScrollPhysics(),
                  primary: false,
                  //宽高比 默认1
//            childAspectRatio: 3 / 4,
//          children: searchHintTexts.map((i) {
////            return Container(color: Colors.red,child: Text(i,style: TextStyle(color: Colors.grey),),);
//          }).toList(),
                  children: List.generate(searchHintTexts.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        NavigatorUtil.push(context,
                            Routers.searchProductListPage + "?searchText=" +  FluroConvertUtils.fluroCnParamsEncode(searchHintTexts[index].toString()));

                      },
                      child: Container(
                        child: Text(
                          searchHintTexts[index],
                          style: TextStyle(fontSize: 13, color: Color(0xFF565757)),
                        ),
                      ),
                    );
                  }, growable: false),
                )),
          )
        ],
      ),
    );
  }
}
