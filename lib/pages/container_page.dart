import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tbk_app/pages/product/product_deatil_page.dart';
import 'package:tbk_app/pages/user/login/login_page.dart';
import 'package:tbk_app/pages/user/user_info_page.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/res/gzx_style.dart';
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


  String tocken;
   int _selectIndex = 0;

  Color _bottomNavigationColor = Color(0xFF585858);
  Color _bottomNavigationActiveColor = Colours.appbar_red;

  @override
  void initState() {
    super.initState();

    // 在当前页面放一个观察者。
    WidgetsBinding.instance.addObserver(this);
    pages
      ..add(HomePage())
      ..add(CatePage())
      ..add(ProductDetail('588618803525'))
      ..add(MyInfoPage());
    tocken =
        SpUtil.getString("tocken") == null ? "" : SpUtil.getString("tocken");
  }

  Widget _buildBarItemTitle(String text, int index) {
    return Text(
      text,
      style: TextStyle(
          color: _selectIndex == index ? _bottomNavigationActiveColor : _bottomNavigationColor, fontSize: 12),
    );
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
    if (clipboardData != null &&
        clipboardData.text.trim() != '' &&
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
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.home,
                color: _selectIndex == 0 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.home_active,
                color: _selectIndex == 0 ? _bottomNavigationActiveColor : _bottomNavigationColor,
                size: 34,
              ),
              title: _selectIndex == 0 ? Container() : _buildBarItemTitle('首页', 0)
          ),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.we_tao,
                color: _selectIndex == 1 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.we_tao_fill,
                color: _selectIndex == 1 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('微淘', 1)),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.cart,
                color: _selectIndex == 2 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.cart_fill,
                color: _selectIndex == 2 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('购物车', 2)),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.my,
                color: _selectIndex == 3 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.my_fill,
                color: _selectIndex == 3 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('我的乐享', 3)),
        ],
        onTap: (int index) {
          if (index == 3 && (tocken == null || tocken == '')) {
            FullScreenDialogUtil.openFullDialog(context, LoginPage());
          } else {
            ///这里根据点击的index来显示，非index的page均隐藏
            setState(() {
              _selectIndex = index;
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
  String name;

  IconData icon;
  IconData icon_active;

  _Item(
    this.name,
    this.icon,
    this.icon_active,
  );
}
