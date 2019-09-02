import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tbk_app/pages/user/login/login_page.dart';
import 'package:tbk_app/pages/user/setting/update_dialog.dart';
import 'package:tbk_app/pages/user/user_info_page.dart';
import 'package:tbk_app/pages/product/product_deatil_page.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/full_screen_dialog_util.dart';
import 'package:tbk_app/util/sp_util.dart';
import 'package:tbk_app/widgets/search_dialog.dart';

import 'cate/cate_page.dart';
import 'home/home_page.dart';

///这个页面是作为整个APP的最外层的容器，以Tab为基础控制每个item的显示与隐藏
class ContainerPage extends StatefulWidget {
  ContainerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}

class _ContainerPageState extends State<ContainerPage>
    with WidgetsBindingObserver {
//  final ShopPageWidget shopPageWidget  = ShopPageWidget();
  List<Widget> pages = new List<Widget>();

  final itemNames = [
    _Item('首页', 'assets/images/sys/ic_tab_home_active.png',
        'assets/images/sys/ic_tab_home_normal.png'),
    _Item('分类', 'assets/images/sys/ic_tab_subject_active.png',
        'assets/images/sys/ic_tab_subject_normal.png'),
    _Item('社区', 'assets/images/sys/ic_tab_shequ_active.png',
        'assets/images/sys/ic_tab_shequ_normal.png'),
    _Item('我的', 'assets/images/sys/ic_tab_profile_active.png',
        'assets/images/sys/ic_tab_profile_normal.png')
  ];
  String tocken;
  List<BottomNavigationBarItem> itemList;
  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();

    // 在当前页面放一个观察者。
    WidgetsBinding.instance.addObserver(this);
    pages..add(HomePage())..add(CatePage())..add(
        ProductDetail('588618803525'))..add(MyInfoPage());
    tocken =
    SpUtil.getString("tocken") == null ? "" : SpUtil.getString("tocken");

    if (itemList == null) {
      itemList = itemNames
          .map(
            (item) =>
            BottomNavigationBarItem(
              icon: Image.asset(item.normalIcon, width: 25.0, height: 25.0),
              title: Text(item.name, style: TextStyle(fontSize: 12.0)),
              activeIcon:
              Image.asset(item.activeIcon, width: 24.0, height: 24.0),
            ),
      )
          .toList();
    }
  }

  @override
  void dispose() {
    // 移除当前页面的观察者。
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当App生命周期状态为恢复时。
    if (state == AppLifecycleState.resumed) {
      getClipboardContents();
    }
  }

  @override
  void didUpdateWidget(ContainerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  /// 使用异步调用获取系统剪贴板的返回值。
  getClipboardContents() async {
    // 访问剪贴板的内容。
    ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String searchText = SpUtil.getString("searchText");

    // 剪贴板不为空时。
    if (clipboardData != null && clipboardData.text.trim() != '' &&
        (searchText == null || searchText != clipboardData.text.trim())) {
      String _name = clipboardData.text.trim();
      // 淘口令的正则表达式，能判断类似“￥123456￥”的文本。
      //      if (RegExp(r'[\uffe5]+.+[\uffe5]').hasMatch(_name)) {
      // 处理淘口令的业务逻辑。
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SearchDialog(_name);
        },
      );
      SpUtil.putString("searchText", _name);
      //      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      bottomNavigationBar: BottomNavigationBar(
        items: this.itemList,
        onTap: (int index) {
          if (index == 3 && (tocken == null || tocken == '')) {
            FullScreenDialogUtil.openFullDialog(context, LoginPage());
          } else {
            ///这里根据点击的index来显示，非index的page均隐藏
            setState(() {
              _selectIndex = index;
              //这个是用来控制比较特别的shopPage中WebView不能动态隐藏的问题
              //shopPageWidget.setShowState(pages.indexOf(shopPageWidget) == _selectIndex);
            });
          }
        },

        ///图标大小
        iconSize: 24,

        ///当前选中的索引
        currentIndex: _selectIndex,

        ///选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type:
        ///BottomNavigationBarType.fixed,时生效）
        fixedColor: Colours.appbar_red,
        type: BottomNavigationBarType.fixed,
      ),
      body: IndexedStack(
        index: _selectIndex,
        children: pages,
      ),
    );
  }
}

/// vo 对象
class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}
