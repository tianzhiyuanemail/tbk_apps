/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/config/service_method.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';

class SearchProductListPage extends StatefulWidget {
  String searchText;

  SearchProductListPage(this.searchText);

  @override
  _SearchProductListPage createState() => _SearchProductListPage();
}

class _SearchProductListPage extends State<SearchProductListPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();
  GlobalKey<RefreshFooterState> _refreshFooterState =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
      GlobalKey<RefreshHeaderState>();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  List goodsList = [];
  int page = 0;



  /// 排序相关
  String s1 = "total_sales";
  String s2 = "_des";
//  排序_des（降序），排序_asc（升序），
//  销量（total_sales）， 人气（tk_total_sales），价格（price）
  String up = "_des";
  String down = "_asc";
  String total_sales = "total_sales";
  String price = "price";
  /// 排序相关

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getGoods();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          setState(() {
            showToTopBtn = false;
          });
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });

    super.initState();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black12,
          ),
          onPressed: () {
            Application.router.pop(context);
          },
        ),
        //导航栏和状态栏的的颜色
        elevation: 0,
        //阴影的高度
        brightness: Brightness.light,
        centerTitle: true,
        //标题是否居中，默认为false
        //        toolbarOpacity: 0.5, //整个导航栏的不透明度
        bottomOpacity: 1,
        //bottom的不透明度
        titleSpacing: 5,
        //标题两边的空白区域,
        title: Container(
          width: MediaQuery.of(context).size.width,
          alignment: AlignmentDirectional.center,
          height: 30.0,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 237, 236, 237),
              borderRadius: BorderRadius.circular(24.0),),
          child: TextField(
            onTap: () {},
            onSubmitted: (s) {},
            autofocus: true,
            maxLines: 1,
            keyboardType: TextInputType.text,
            cursorColor: Color.fromARGB(255, 0, 189, 96),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 8.0),
                border: InputBorder.none,
                hintText: widget.searchText,
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 192, 191, 191),
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: Color.fromARGB(255, 128, 128, 128),
                  ),
                )),
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: EasyRefresh(
        refreshFooter: EasyRefreshUtil.classicsFooter(_refreshFooterState),
        refreshHeader: EasyRefreshUtil.classicsHeader(_refreshHeaderState),
        loadMore: () async {
          _getGoods();
        },
        onRefresh: () async {
          getHomePageGoods(1).then((val) {
            List swiper = val['data'];
            setState(() {
              goodsList = swiper;
              page = 1;
            });
          });
        },
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            _buildStickyBar(),
            SliverProductListSliverGrid(list: goodsList),
          ],
        ),
      ),
    );
  }




  Widget _buildStickyBar() {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        maxHeight: 30.0,
        minHeight: 30.0,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black12, width: 0.1),
              bottom: BorderSide(color: Colors.black12, width: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    s1 = total_sales;
                    s2 = s2 == up ? down : up;
                  });
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("销量",style: TextStyle(color: s1 == total_sales? Colors.redAccent:null),),
                      Icon(
                        (s1+s2) == total_sales+up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: s1 == total_sales? Colors.redAccent:null,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    s1 = price;
                    s2 = s2 == up ? down : up;
                  });
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("价格",style: TextStyle(color: s1 == price? Colors.redAccent:null),),
                      Icon(
                        s1+s2 == price+up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: s1 == price? Colors.redAccent:null,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      s1 = total_sales;
                      s2 = s2 == up ? down : up;
                    });
                  },
                  child: Container(
                    child: Icon(
                      s2 == up ? Icons.list : Icons.list,
                      color: s1 == price? Colors.redAccent:null,
                      size: 22,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _getGoods() {
    getHomePageGoods(page).then((val) {
      List swiper = val['data'];
      setState(() {
        goodsList.addAll(swiper);
        page++;
      });
    });
  }
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
