import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String hintText;
  bool status = false;

  ScrollController _controller = new ScrollController();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  final FocusNode _nodeText1 = FocusNode();

  void _onSubmitted(String searchText) {
    print(searchText);
    FocusScope.of(context).requestFocus(FocusNode());
    NavigatorUtil.push(context,
        Routers.searchProductListPage + "?searchText=" +  FluroConvertUtils.fluroCnParamsEncode(searchText.toString()));
  }

  @override
  void initState() {
    super.initState();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });

  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              Application.router.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Text(
                "取消",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ],
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        bottomOpacity: 1,
        titleSpacing: 10,
        title: defaultTargetPlatform == TargetPlatform.iOS
            ? SingleChildScrollView(
                child: _buildTitle(),
              )
            : SingleChildScrollView(
                child: _buildTitle(),
              ),
      ),
      body: _buildHotLogs()
    );
  }

  Widget _buildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: AlignmentDirectional.center,
      height: 30.0,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 237, 236, 237),
          borderRadius: BorderRadius.circular(24.0)),
      child: TextField(
        onTap: () {
          print("获取焦点");
        },
        focusNode: _nodeText1,
        onSubmitted: _onSubmitted,
        autofocus: true,
        maxLines: 1,
        keyboardType: TextInputType.text,
        keyboardAppearance: Brightness.light,
        cursorColor: Colours.text_gray,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 8.0),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyles.textGray16,
          prefixIcon: Container(
            margin: EdgeInsets.only(top: 0),
            child: Icon(
              Icons.search,
              size: 20,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ),
        ),
        style: TextStyles.textNormal16,
      ),
    );
  }


  Widget  _buildHotLogs() {
    return Container(
      child: ListView(
        controller: _controller,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("热门搜索"),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: new NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          //横轴数量
                          crossAxisSpacing: 0.0,
                          //横轴间距
                          mainAxisSpacing: 0.0,
                          //纵轴间距
                          childAspectRatio: 5,
                          //横纵比例 长宽只能这个属性设置
                          children: new List(10).map((v) {
                            return Text("超声波电动牙刷");
                          }).toList(),
                        ),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("历史记录"),
                          Text("清除"),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: new NeverScrollableScrollPhysics(),
                          crossAxisCount: 5,
                          //横轴数量
                          crossAxisSpacing: 0.0,
                          //横轴间距
                          mainAxisSpacing: 0.0,
                          //纵轴间距
                          childAspectRatio: 2,
                          //横纵比例 长宽只能这个属性设置
                          children: new List(24).map((v) {
                            return Text("男装");
                          }).toList(),
                        ),
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}


