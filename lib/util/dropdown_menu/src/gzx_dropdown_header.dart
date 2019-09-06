import 'package:flutter/material.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'gzx_dropdown_menu_controller.dart';
import 'dart:math' as math;

class GZXDropDownHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final String title;
  SortModle sortModle;
  final GZXDropdownMenuController controller;
  final GlobalKey stackKey;
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;
  final Function onTap3;

  @override
  _GZXDropDownHeaderState createState() => _GZXDropDownHeaderState();

  GZXDropDownHeader({
    Key key,
    @required this.title,
    @required this.sortModle,
    @required this.controller,
    @required this.stackKey,
    @required this.scaffoldKey,
    this.onTap0,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);
}

class _GZXDropDownHeaderState extends State<GZXDropDownHeader>
    with SingleTickerProviderStateMixin {
  double _screenWidth;
  int selectCount = 0;
  GlobalKey _keyDropDownHearder = GlobalKey();

  TextStyle style = const TextStyle(color: Color(0xFF666666), fontSize: 13);
  TextStyle dropDownStyle;
  final double iconSize = 20;
  final Color iconColor = const Color(0xFFafada7);
  Color iconDropDownColor;
  final double height = 40;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.controller.addListener(_onController);
  }

  _onController() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    dropDownStyle ??=
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);
    iconDropDownColor ??= Theme.of(context).primaryColor;

    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;

    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        maxHeight: 50,
        minHeight: 50,
        child: Container(
          key: _keyDropDownHearder,
          height: height,
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFeeede6), width: 0),
          ),
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: (_screenWidth / 4) / height,
            children: <Widget>[
              _menu0(),
              _menu1(),
              _menu2(),
              _menu3(),
            ],
          ),
        ),
      ),
    );
  }

  dispose() {
    super.dispose();
  }

  /// 综合
  _menu0() {
    return GestureDetector(
      onTap: () {
        final RenderBox overlay =
            widget.stackKey.currentContext.findRenderObject();

        final RenderBox dropDownItemRenderBox =
            _keyDropDownHearder.currentContext.findRenderObject();

        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
        var size = dropDownItemRenderBox.size;
        widget.controller.dropDownHearderHeight = size.height + position.dy;

        if (widget.controller.isShow) {
          widget.controller.hide();
        } else {
          widget.controller.show(0);
        }

        setState(() {
          selectCount = 0;
        });
      },
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: selectCount == 0 ? dropDownStyle : style,
                    )),
                    Icon(
                      selectCount == 0
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      color: selectCount == 0 ? iconDropDownColor : iconColor,
                      size: iconSize,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// 销量
  _menu1() {
    return GestureDetector(
      onTap: () {
        if (widget.controller.isShow) {
          widget.controller.hide();
        }
        setState(() {
          selectCount = 1;
        });
        widget.sortModle.sortStr = SortConstant.map['销量'];

        widget.sortModle.zongheSortConditions =
            SortConstant.zongheSortConditions.map((f) {
          int i = SortConstant.zongheSortConditions.indexOf(f);
          if (i == 0) {
            f.isSelected = true;
          } else {
            f.isSelected = false;
          }
          return f;
        }).toList();
        widget.sortModle.title = SortConstant.zongheSortConditions[0].name;
        widget.onTap1(widget.sortModle);
      },
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      '销量',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: selectCount == 1 ? dropDownStyle : style,
                    )),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// 单行 双行
  _menu2() {
    return GestureDetector(
      onTap: () {
        if (widget.controller.isShow) {
          widget.controller.hide();
        }
        setState(() {
          widget.sortModle.single = !widget.sortModle.single;
        });
        widget.onTap2(widget.sortModle);
      },
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.sortModle.single
                          ? GZXIcons.list : GZXIcons.cascades,
                      color: iconColor,
                      size: iconSize,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  /// 筛选
  _menu3() {
    return GestureDetector(
      onTap: () {
        final RenderBox overlay =
            widget.stackKey.currentContext.findRenderObject();

        final RenderBox dropDownItemRenderBox =
            _keyDropDownHearder.currentContext.findRenderObject();

        var position =
            dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
        var size = dropDownItemRenderBox.size;
        widget.controller.dropDownHearderHeight = size.height + position.dy;

        if (widget.controller.isShow) {
          widget.controller.hide();
        } else {
          widget.controller.show(3);
        }
        widget.scaffoldKey.currentState.openEndDrawer();

        setState(() {});
      },
      child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      "筛选",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style,
                    )),
                    Icon(
                      GZXIcons.filter,
                      color: iconColor,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class SortConstant {
  //  排序_des（降序），排序_asc（升序），
  //  销量（total_sales）， 人气（tk_total_sales），价格（price）
  static String _des = "_des";
  static String _asc = "_asc";

  static String _total_sales = "total_sales";
  static String _tk_total_sales = "tk_total_sales";
  static String _price = "price";

  static Map<String, String> map = {
    '综合': SortConstant._price + SortConstant._des,
    '价格从低到高': SortConstant._price + SortConstant._des,
    '价格从高到低': SortConstant._price + SortConstant._des,
    '销量': SortConstant._price + SortConstant._des,
  };

  static List<SortCondition> zongheSortConditions = [
    SortCondition(name: '综合', isSelected: true),
    SortCondition(name: '价格从高到低', isSelected: false),
    SortCondition(name: '价格从低到高', isSelected: false)
  ];
}

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

class SortModle {
  // 排序方式默认 价格降序
  String sortStr;

  ///
  bool single;

  String title;

  List<SortCondition> zongheSortConditions;

  SortModle({this.sortStr, this.single, this.title, this.zongheSortConditions});
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max((minHeight ?? kToolbarHeight), minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
