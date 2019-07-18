/*
 */

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_html_widget/flutter_html_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tbk_app/config/service_method.dart';
import 'package:tbk_app/modle/product_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:nautilus/nautilus.dart' as nautilus;
import 'package:nautilus/nautilus.dart';

import '../../entity_factory.dart';
import '../../entity_list_factory.dart';

// ignore: must_be_immutable
class ProductDetail extends StatefulWidget {
  String productId;

  ProductDetail(this.productId);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ScrollController _controller = ScrollController();
  GlobalKey<RefreshFooterState> _refreshFooterState =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
      GlobalKey<RefreshHeaderState>();

  bool showToTopBtn = false;

  ///是否显示“返回到顶部”按钮
  bool showSliverPersistentHeader = false;

  ///是否显示 导航栏

  ProductEntity productEntity;
  List<ProductListEntity> productList = [];

  @override
  void initState() {
    super.initState();

    _getProductInfo();

    ///监听滚动事件
    _controller.addListener(() {
      /// 导航栏监听
      if (_controller.offset < 200) {
        setState(() {
          showSliverPersistentHeader = false;
        });
      } else {
        setState(() {
          showSliverPersistentHeader = true;
        });
      }

      ///是否显示“返回到顶部”按钮
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });

    /// todo 商品推荐接口 暂时调用首页商品接口
    getHomePageGoods(1).then((val) {
      List<ProductListEntity> list =
          EntityListFactory.generateList<ProductListEntity>(val['data']);

      setState(() {
        productList.addAll(list);
      });
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
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: productEntity == null
          ? CupertinoActivityIndicator()
          : Stack(
              children: <Widget>[
                EasyRefresh(
                  refreshFooter:
                      EasyRefreshUtil.classicsFooter(_refreshFooterState),
                  refreshHeader:
                      EasyRefreshUtil.classicsHeader(_refreshHeaderState),
                  loadMore: () async {},
                  onRefresh: () async {},
                  child: _customScrollView(),
                ),
                Offstage(
                  offstage: !showSliverPersistentHeader,
                  child: ProductHeaderChild(
                      showSliverPersistentHeader: showSliverPersistentHeader),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(productEntity: productEntity),
                )
              ],
            ),
    );
  }

  /// 调用后台商品接口
  void _getProductInfo() {
    HttpUtil()
        .get('getProductInfo', parms: 'productId=' + widget.productId)
        .then((val) {
      setState(() {
        productEntity =
            EntityFactory.generateOBJ<ProductEntity>(val['data']['product']);
      });
    });
  }

  /// CustomScrollView  实现列表 以后备用
  CustomScrollView _customScrollView() {
    return CustomScrollView(
      controller: _controller,
      reverse: false,
      slivers: <Widget>[
        //SliverToBoxAdapter(child: null),
//        SliverPersistentHeader(
//          pinned: true, //是否固定在顶部
//          floating: true,
//          delegate: _SliverAppBarDelegate(
//            maxHeight: showSliverPersistentHeader ? 50 : 0.0,
//            minHeight: showSliverPersistentHeader ? 50 : 0.0,
//            child: ProductHeaderChild(
//                showSliverPersistentHeader:
//                showSliverPersistentHeader),
//          ),
//        ),
        SliverList(
          delegate: SliverChildListDelegate(_sliverListChild()),
        )
      ],
    );
  }

  /// CustomScrollView _sliverListChild
  List<Widget> _sliverListChild() {
    List<Widget> list = List();

    list.add(SwiperDiy(list: productEntity.smallImages));
    list.add(ProductInfomation(productEntity: productEntity));
    list.add(ShopInfomation(productEntity: productEntity));
    list.add(ItemDetails(productEntity: productEntity));
    list.add(ProductRecommend(list: productList));
    return list;
  }

  /// _listView
  ListView _listView() {
    return ListView(
      controller: _controller,
      children: <Widget>[
        SwiperDiy(list: productEntity.smallImages),
        ProductInfomation(productEntity: productEntity),
        ShopInfomation(productEntity: productEntity),
        ItemDetails(productEntity: productEntity),
        ProductRecommend(list: productList),
      ],
    );
  }
}

/// 自定义导航栏
class ProductHeaderChild extends StatelessWidget {
  bool showSliverPersistentHeader;

  ProductHeaderChild({this.showSliverPersistentHeader});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showSliverPersistentHeader ? Colors.white : Colors.transparent,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      padding: EdgeInsets.only(top: 14, bottom: 0),
      height: 50,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              Application.router.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}

/// 轮播组件编写
class SwiperDiy extends StatelessWidget {
  List list = [];

  SwiperDiy({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(750),
      width: ScreenUtil().setWidth(750),
      child: Stack(
        children: <Widget>[
          Swiper(
            index: 0,
            itemBuilder: (BuildContext context, int index) {
              return Image.network("${list[index]}", fit: BoxFit.fill);
            },
            itemCount: list.length,
            pagination: new SwiperPagination(),
            autoplay: false,
          ),
          Offstage(
            offstage: false,
            child: ProductHeaderChild(showSliverPersistentHeader: false),
          )
        ],
      ),
    );
  }
}

/// 商品基础信息
class ProductInfomation extends StatelessWidget {
  ProductEntity productEntity;

  ProductInfomation({this.productEntity});

  Widget _row1() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.pink.shade300,
                wordSpacing: 4,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: "券后  ", style: TextStyle(
                  fontSize: 14,
                )),
                TextSpan(
                  text: '¥${productEntity.afterCouponPrice}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.pink,

                  ),
                ),
              ],
            ),
          )),
          Container(
            padding: EdgeInsets.only(left: 3, right: 3, bottom: 1),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2)),
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.red,
                  wordSpacing: 4,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: "预估收益:¥ ", style: TextStyle()),
                  TextSpan(
                    text: "${productEntity.estimatedRevenueAmount}",
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row2() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Text.rich(
            TextSpan(
              text: "原价 ¥ ${productEntity.zkFinalPrice}",
              style: TextStyle(
                color: Colors.black38,
                wordSpacing: 4,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          )),
          Container(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.black38,
                  wordSpacing: 4,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text: "已售${productEntity.tkTotalSales}",
                      style: TextStyle()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row3() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            width: 25,
            padding: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0.5),
            decoration: BoxDecoration(
                border: Border.all(width: 0.70, color: Colors.red),
                borderRadius: BorderRadius.circular(2)),
            child: Text(
              productEntity.userType == 1 ? "天猫" : "淘宝",
              style: TextStyle(fontSize: 8),
            ),
          ),
          Text(
            "          ${productEntity.title}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row4() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        padding: EdgeInsets.only(left: 3, right: 3, bottom: 1),
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 5),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 9,
                    ),
                    children: [
                      TextSpan(text: "升级运营商，即可获得更高收益", style: TextStyle()),
                    ],
                  ),
                )),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      "了解详情",
                      style: TextStyle(color: Colors.pink, fontSize: 9),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.only(left: 3, right: 3, bottom: 1),
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      ">",
                      style: TextStyle(color: Colors.pink, fontSize: 6),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Column(
        children: <Widget>[
          _row1(),
          _row2(),
          _row3(),
          _row4(),
        ],
      ),
    );
  }
}

/// 店铺基础信息
class ShopInfomation extends StatelessWidget {
  ProductEntity productEntity;

  ShopInfomation({this.productEntity});

  Widget _row1() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Stack(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://b-ssl.duitang.com/uploads/item/201601/08/20160108194244_JxGRy.thumb.700_0.jpeg"),
                    ),
                    borderRadius: BorderRadius.circular(7)),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 40, top: 7),
                child: Text(
                  "七公主旗舰店",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
          Container(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  wordSpacing: 4,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: "进入店铺", style: TextStyle()),
                  TextSpan(
                    text: ">",
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row2Child(String v1, String v2, String v3) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.zero,
            child: Text(
              v1,
              style: TextStyle(
                color: Colors.black,
                wordSpacing: 4,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              v2,
              style: TextStyle(
                color: Colors.green,
                wordSpacing: 4,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 3),
            padding: EdgeInsets.only(left: 1, right: 1),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(2)),
            child: Text(
              v3,
              style: TextStyle(
                color: Colors.white,
                wordSpacing: 4,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row2() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _row2Child("宝贝描述", "4.8", "低"),
          _row2Child("卖家服务", "4.8", "低"),
          _row2Child("物流服务", "4.8", "低"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
      child: Column(
        children: <Widget>[
          _row1(),
          _row2(),
        ],
      ),
    );
  }
}

/// 商品详情页
class ItemDetails extends StatefulWidget {
  ProductEntity productEntity;

  ItemDetails({this.productEntity});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

/// 商品详情页 State
class _ItemDetailsState extends State<ItemDetails> {
  bool hidden;
  String richText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hidden = true;
    richText = '';
  }

  void _getItemDeatilRichText() {
    if (richText == '' || richText == null) {
      HttpUtil()
          .get('getProductDetail',
              parms: 'data=%7B"id":"${widget.productEntity.itemId}"%7D')
          .then((val) {
        setState(() {
          hidden = !hidden;
          richText = val['data']['pcDescContent'].toString();
        });
      });
    } else {
      setState(() {
        hidden = !hidden;
      });
    }
  }

  Widget _itemDetailsTexg() {
    return InkWell(
      onTap: _getItemDeatilRichText,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text("查看详情"),
            ),
            Container(
              child: Text(hidden ? ">" : "<"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDeatilRichText() {
    return Container(
      child: Offstage(
        offstage: hidden,
        child: HtmlWidget(html: richText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
      child: Column(
        children: <Widget>[
          _itemDetailsTexg(),
          _itemDeatilRichText(),
        ],
      ),
    );
  }
}

/// 猜你喜欢

class ProductRecommend extends StatelessWidget {
  List list;

  ProductRecommend({this.list});

  Widget _recommendText() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 60,
          height: 1,
          color: Colors.red,
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.video_label,
            size: 20,
            color: Colors.cyan,
            textDirection: TextDirection.ltr,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            "猜你喜欢",
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          width: 60,
          height: 1,
          color: Colors.red,
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
      child: Column(
        children: <Widget>[
          _recommendText(),
          ProductList(
            list: list,
            crossAxisCount: 2,
          ),
        ],
      ),
    );
  }
}

class DetailsBottom extends StatelessWidget {
  ProductEntity productEntity;

  DetailsBottom({this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              NavigatorUtil.gotransitionPage(context, Routers.root);
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/ic_tab_home_normal.png',
                      width: 30.0, height: 30.0),
                  Text(
                    "首页",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/ic_tab_home_normal.png',
                      width: 30.0, height: 30.0),
                  Text(
                    "收藏",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  Map<String, String> taoKeParamsextraParams = new Map();
                  taoKeParamsextraParams['taokeAppkey'] = '24900413';

                  Map<String, String> extraParams = new Map();
                  extraParams['isv_code'] = 'appisvcode';

                  nautilus.openUrl(
                      pageUrl: productEntity.couponShareUrl,
                      openType: nautilus.OpenType.NATIVE,
                      schemeType: "taobao_oscheme",
                      extParams: extraParams);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(220),
                  height: ScreenUtil().setHeight(70),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/ic_tab_home_normal.png',
                          width: 30.0, height: 30.0),
                      Text(
                        '  分享',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28)),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Map<String, String> taoKeParamsextraParams = new Map();
                  taoKeParamsextraParams['taokeAppkey'] = '24900413';

                  Map<String, String> extraParams = new Map();
                  extraParams['isv_code'] = 'appisvcode';

                  nautilus.openItemDetail(
                      itemID: productEntity.itemId.toString(),
                      taoKeParams: nautilus.TaoKeParams(
                          unionId: "",
                          subPid: "mm_114747138_45538443_624654015",
                          pid: "mm_114747138_45538443_624654015",
                          adzoneId: "624654015",
                          extParams: taoKeParamsextraParams),
                      openType: nautilus.OpenType.NATIVE,
                      schemeType: "taobao_oscheme",
                      extParams: extraParams);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(250),
                  height: ScreenUtil().setHeight(70),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/ic_tab_home_normal.png',
                          width: 30.0, height: 30.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '  领券',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(28)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
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
