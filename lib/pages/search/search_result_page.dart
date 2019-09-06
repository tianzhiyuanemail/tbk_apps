import 'package:flutter/material.dart';
import 'package:tbk_app/pages/drawer/gzx_filter_goods_page.dart';
import 'package:tbk_app/pages/search/search_result_list_page.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/widgets/my_search_card.dart';


/// 搜索结果页面 顶部导航 + （sort + list数据）
class SearchResultPage extends StatefulWidget {
  final String keywords;

  const SearchResultPage({Key key, this.keywords}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List _tabsTitle = ['全部', '天猫'];
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController _keywordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keywordTextEditingController.text = widget.keywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        endDrawer: GZXFilterGoodsPage(),
        backgroundColor: GZXColors.mainBackgroundColor,
        appBar: PreferredSize(
            child: AppBar(
              brightness: Brightness.light,
              backgroundColor: GZXColors.mainBackgroundColor,
              elevation: 0,
            ),
            preferredSize: Size.fromHeight(0),
        ),
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    GZXIcons.back_light,
                    size: 20,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GZXSearchCardWidget(
                    isShowLeading: false,
                    isShowSuffixIcon: false,
                    textEditingController: _keywordTextEditingController,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            TabBar(
                indicatorColor: Color(0xFFfe5100),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: Color(0xFFfe5100),
                unselectedLabelColor: Colors.black,
                labelPadding: EdgeInsets.only(left: 30, right: 30),
                onTap: (i) {},
                tabs: _tabsTitle.map((i) => Text(i,)).toList()),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: TabBarView(children: _tabsTitle.map((item) {
              return SearchResultListPage(searchText:widget.keywords ,);
            }).toList()))
          ]),
        ));
  }
}
