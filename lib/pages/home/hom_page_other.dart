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
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';

class HomePageOther extends StatefulWidget {
  @override
  _HomePageOtherState createState() => _HomePageOtherState();
}

class _HomePageOtherState extends State<HomePageOther>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();

  GlobalKey<RefreshFooterState> _refreshFooterState =
  GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
  GlobalKey<RefreshHeaderState>();

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  String productId = "1234";
  String productImage =
      "http://kaze-sora.com/sozai/blog_haru/blog_mitubachi01.jpg";

  List secondaryCategoryList = List(10);
  List goodsList = [];
  int page = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getCateGoods();
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
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: EasyRefresh(
        refreshFooter: EasyRefreshUtil.classicsFooter(_refreshFooterState),
        refreshHeader: EasyRefreshUtil.classicsHeader(_refreshHeaderState),
        loadMore: () async {
          _getCateGoods();
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
            CateHotProduct(
              productImage: productImage,
              productId: productId,
            ),
            SecondaryCategory(
              secondaryCategoryList: secondaryCategoryList,
            ),
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
        maxHeight: 50.0,
        minHeight: 50.0,
        child: Container(
          padding: EdgeInsets.only(left: 16),
          color: Colors.blue,
          alignment: Alignment.centerLeft,
          child: Text("浮动", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  void _getCateGoods() {
    getHomePageGoods(page).then((val) {
      List swiper = val['data'];
      setState(() {
        goodsList.addAll(swiper);
        page++;
      });
    });
  }
}

class CateHotProduct extends StatelessWidget {
  final String productImage;
  final String productId;

  CateHotProduct(
      {Key key, @required this.productId, @required this.productImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          print(productId);
        },
        child: Image.network(productImage),
      ),
    );
  }
}

class SecondaryCategory extends StatelessWidget {
  final List secondaryCategoryList;

  SecondaryCategory({Key key, this.secondaryCategoryList}) : super(key: key);

  Widget _itemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(
            'http://e.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9eac1754f45df39b6003bf3b396.jpg',
            width: ScreenUtil().setHeight(95),
          ),
          Text("首页")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: ScreenUtil().setHeight(320),
        padding: EdgeInsets.all(3.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(4.0),
          children: secondaryCategoryList.map((item) {
            return _itemUI(context, item);
          }).toList(),
        ),
      ),
    );
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
