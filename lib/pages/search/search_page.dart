import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String hintText;
  bool status = false;

  final FocusNode _nodeText1 = FocusNode();

  void _onSubmitted(String searchText) {
    print(searchText);
    NavigatorUtil.gotransitionPage(context,
        Routers.searchProductListPage + "?searchText=" + searchText.toString());
  }

  @override
  void initState() {
    super.initState();
    KeyboardActionsConfig config = Utils.getKeyboardActionsConfig([_nodeText1]);
    if ( defaultTargetPlatform == TargetPlatform.iOS) {
      // 因Android平台输入法兼容问题，所以只配置IOS平台
       FormKeyboardActionState state = context
          .ancestorStateOfType(const TypeMatcher<FormKeyboardActionState>());
       if(state != null){
         FormKeyboardActions.setKeyboardActions(context, config);
       }
    }
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
//            title: defaultTargetPlatform == TargetPlatform.iOS
//                ? SingleChildScrollView(
//                    child: _buildTitle(),
//                  )
//                : SingleChildScrollView(
//                    child: _buildTitle(),
//                  )),
    title: _buildTitle(),
        ),
        body: HotLogs());
  }

  Widget _buildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: AlignmentDirectional.center,
      height: 30.0,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 237, 236, 237),
          borderRadius: BorderRadius.circular(24.0)
      ),
      child: TextField(
        onTap: () {
          print("获取焦点");
        },
        focusNode: _nodeText1,
        onSubmitted: _onSubmitted,
        autofocus: true,
        maxLines: 1,
        keyboardType: TextInputType.text,
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
        style: TextStyles.textBoldDark16,
      ),
    );
  }

//
//  autocorrect → bool - 是否启用自动更正。
//
//  autofocus → bool - 是否是自动获取焦点。
//
//  controller → TextEditingController - 控制正在编辑的文本。
//
//  decoration → InputDecoration - TextField 的外形描述。
//
//  enabled → bool - 是否禁用。
//
//  focusNode → FocusNode - 是否具有键盘焦点。
//
//  inputFormatters → List<textinputformatter style="-webkit-font-smoothing: antialiased; -webkit-tap-highlight-color: rgba(0, 0, 0, 0); text-size-adjust: none; box-sizing: border-box;"></textinputformatter> - 可选的，输入验证和格式化。
//
//  keyboardType → TextInputType - 用于编辑文本的键盘类型。
//
//  maxLength → int - 文本最大的字符串长度。
//
//  maxLengthEnforced → bool - 如果为true，则防止字段允许超过 maxLength 字符。
//
//  maxLines → int - 文本最大行数，默认为 1。多行时应该设置为 > 1。
//
//  obscureText → bool - 是否是隐藏文本（密码形式）。
//
//  onChanged → ValueChanged - 当 value 改变时触发。
//
//  onSubmitted → ValueChanged - 当用户点击键盘的提交时触发。
//
//  style → TextStyle - 文本样式，颜色，字体等。
//
//  textAlign → TextAlign - 设置文本对齐方式。
//
//  作者：iwakevin
//  链接：https://www.jianshu.com/p/a27e91b3654c
//  来源：简书
//  简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
}

class HotLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
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
