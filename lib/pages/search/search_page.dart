import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tbk_app/pages/search/search_suggest_page.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/widgets/my_search_card.dart';
import 'package:tbk_app/widgets/recomend.dart';

/// 搜索承接页面
class SearchPage extends StatefulWidget {
  final String keywords;

  const SearchPage({Key key, this.keywords}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _tabsTitle = ['全部', '天猫'];
  List<String> recomendWords = [];
  TextEditingController _keywordsTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _keywordsTextEditingController.text = widget.keywords;

    if (widget.keywords != null) {
      seachTxtChanged(widget.keywords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: GZXColors.mainBackgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: GZXSearchCardWidget(
                      elevation: 0,
                      autofocus: true,
                      textEditingController: _keywordsTextEditingController,
                      isShowLeading: false,
                      onSubmitted: (value) {
                        NavigatorUtil.push(
                            context,
                            Routers.searchProductListPage +
                                "?searchText=" +
                                FluroConvertUtils.fluroCnParamsEncode(
                                    value.toString()));
                      },
                      onChanged: (value) {
                        seachTxtChanged(value);
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              Expanded(
                  child: (recomendWords.length == 0
                      ? _buildContentWidget()
                      : RecomendListWidget(recomendWords, onItemTap: (value) {
                          NavigatorUtil.push(
                              context,
                              Routers.searchProductListPage +
                                  "?searchText=" +
                                  FluroConvertUtils.fluroCnParamsEncode(
                                      value.toString()));
                        })))
            ],
          )),
    );
  }

  Widget _buildContentWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        TabBar(
//          controller: widget.tabController,
            indicatorColor: Color(0xFFfe5100),
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
//          labelColor: KColorConstant.themeColor,
            labelColor: Color(0xFFfe5100),
            unselectedLabelColor: Colors.black,
//          labelPadding: EdgeInsets.only(left: (ScreenUtil.screenWidth-30*3)/4),
            labelPadding: EdgeInsets.only(left: 40, right: 40),
            labelStyle: TextStyle(fontSize: 12),
            onTap: (i) {
            },
            tabs: _tabsTitle
                .map((i) => Text(
                      i,
                      style: TextStyle(fontSize: 15),
                    ))
                .toList()),
        SizedBox(
          height: 8,
        ),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            SearchSuggestPage(),
            SearchSuggestPage(),
          ],
        ))
      ],
    );
  }

  void seachTxtChanged(String q) async {
    var result = await getSuggest(q) as List;
    recomendWords = result.map((dynamic i) {
      List item = i as List;
      return item[0] as String;
    }).toList();
    setState(() {});
  }

  Future getSuggest(String q) async {
    String url = 'https://suggest.taobao.com/sug?q=$q&code=utf-8&area=c2c';
    var res = await HttpUtil().get(url);
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body)['result'] as List;
      return data;
    } else {
      return [];
    }
  }
}
