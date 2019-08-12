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
import 'package:tbk_app/modle/product_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/loadingIndicator_util.dart';
import 'package:tbk_app/util/nautilus_util.dart';
import 'package:tbk_app/util/screen.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';

import '../../entity_factory.dart';
import '../../entity_list_factory.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
  bool controllerOffset = false;

  ///是否显示 导航栏

  ProductEntity productEntity;
  List<ProductListEntity> productList = [];

  String richText = '';

  double navAlpha = 0;

  @override
  void initState() {
    super.initState();
    _getHotGoods();
    _getProductInfo();
    _getItemDeatilRichText();

    /// 导航栏监听
    _controller.addListener(() {
      var offset = _controller.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < 50) {
        setState(() {
          navAlpha = 1 - (50 - offset) / 50;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
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
  }

  void _getHotGoods() {
    HttpUtil().get('homePageGoods').then((val) {
      if (val["success"]) {
        List<ProductListEntity> list =
            EntityListFactory.generateList<ProductListEntity>(val['data']);

        setState(() {
          productList.addAll(list);
        });
      }
    });
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

  void _getItemDeatilRichText() {
    HttpUtil()
        .get('getProductDetail', parms: 'data=%7B"id":"${widget.productId}"%7D')
        .then((val) {
      setState(() {
        richText = val['data']['pcDescContent'].toString();
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
      body: Stack(
        children: <Widget>[
          productEntity == null
              ? LoadingIndicatorUtil()
              : EasyRefresh(
                  refreshFooter:
                      EasyRefreshUtil.classicsFooter(_refreshFooterState),
                  refreshHeader:
                      EasyRefreshUtil.classicsHeader(_refreshHeaderState),
                  loadMore: () async {},
                  onRefresh: () async {},
                  child: _customScrollView(),
                ),
          buildNavigationBar(),
          Positioned(
            bottom: 80,
            right: 20,
            child: BackTopButton(
                controller: _controller, showToTopBtn: showToTopBtn),
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

  Widget buildNavigationBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          child: Container(
            margin: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            child: buildActions(Colors.red),
          ),
        ),
        Opacity(
          opacity: navAlpha,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            height: Screen.navigationBarHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                buildActions(Colors.blue),
                Expanded(
                  child: Text(
                    '商品详情',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildActions(Color iconColor) {
    return Row(children: <Widget>[
      IconButton(
        onPressed: () {
          Application.router.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
    ]);
  }

  /// CustomScrollView  实现列表 以后备用
  CustomScrollView _customScrollView() {
    return CustomScrollView(
      controller: _controller,
      reverse: false,
      slivers: <Widget>[
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
//    list.add(ShopInfomation(productEntity: productEntity));
    list.add(ItemDetails(richText: richText));
    list.add(ProductRecommend(list: productList));
    return list;
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
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                  color: Colors.white,
                  // 其他点的颜色
                  activeColor: Colors.pink,
                  // 当前点的颜色
                  space: 8,
                  // 点与点之间的距离
                  activeSize: 8,
                  // 当前点的大小
                  size: 8),
            ),
            autoplay: false,
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 3, right: 5),
            child: Image.asset(
              productEntity.userType == 1
                  ? 'assets/images/taobao/tianmao.png'
                  : 'assets/images/taobao/taobao.png',
              width: 14,
              fit: BoxFit.contain,
              height: 14,
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(580),
            child: Text(
              "${productEntity.title}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 5, top: 3, right: 0),
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  )),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.reply,
                    color: Colors.black26,
                    size: 14,
                  ),
                  Text(
                    "分享",
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _row2() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
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
                  TextSpan(
                      text: "券后 ",
                      style: TextStyle(
                        fontSize: 14,
                      )),
                  TextSpan(
                    text: '¥${productEntity.afterCouponPrice}',
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
                    ),
                  ),
//                  TextSpan(
//                    text: '  ',
//                  ),
//                  TextSpan(
//                    text: "${productEntity.zkFinalPrice}",
//                    style: TextStyle(
//                        color: Colors.black54,
//                        fontSize: ScreenUtil().setSp(20),
//                        decoration: TextDecoration.lineThrough,
//                        decorationStyle: TextDecorationStyle.dashed),
//                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 3, right: 3, bottom: 1),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2)),
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Colors.pink,
                  wordSpacing: 4,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text: "预估收益:¥ ",
                      style: TextStyle(
                        color: Colors.pink,
                      )),
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

  Widget _row3() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
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
                      text: "已售${productEntity.volume}", style: TextStyle()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row31() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
//            width: 40,
            margin: EdgeInsets.only(left: 0, right: 10, bottom: 0, top: 0),
            padding: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
            decoration: BoxDecoration(
              color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
              border: Border.all(
                  width: 0.70,
                  color: ColorsUtil.hexToColor(ColorsUtil.appBarColor)),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              "推荐语",
              style:
                  TextStyle(fontSize: 8, color: Colors.white, letterSpacing: 2),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(610),
            child: Text(
              "${productEntity.itemDescription}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row4() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(10),
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
      padding: EdgeInsets.only(left: 10, right: 0, top: 5),
      child: Column(
        children: <Widget>[
          _row1(),
          _row2(),
          _row3(),
          productEntity.itemDescription.isEmpty ? Container() : _row31(),
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
                    productEntity.shopTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          _row2Child("宝贝描述", "4.8", "高"),
          _row2Child("卖家服务", "4.8", "高"),
          _row2Child("物流服务", "4.8", "高"),
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
class ItemDetails extends StatelessWidget {
  String richText;

  ItemDetails({this.richText});

  Widget _itemDeatilRichText() {
    return Container(
      child: HtmlWidget(html: richText),
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
          TextLine(
            text: "宝贝详情",
          ),
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
      padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 10),
      child: Column(
        children: <Widget>[
          _recommendText(),
          ProductList(
            list: list,
            crossAxisCount: 1,
          ),
        ],
      ),
    );
  }
}

class TextLine extends StatelessWidget {
  String text;

  TextLine({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 60,
          height: 1,
          color: Colors.red,
        ),
//            Container(
//              margin: EdgeInsets.only(left: 20),
//              child: Icon(
//                Icons.video_label,
//                size: 20,
//                color: Colors.cyan,
//                textDirection: TextDirection.ltr,
//              ),
//            ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            this.text,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              NavigatorUtil.gotransitionPage(context, Routers.root);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10),
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
                  Image.asset(
                    true
                        ? 'assets/images/product_detail/like_a.png'
                        : 'assets/images/product_detail/like.png',
                    width: 28.0,
                    height: 30.0,
                  ),
                  Text(
                    "喜欢",
                    style: TextStyle(
                      color: true
                          ? ColorsUtil.hexToColor(ColorsUtil.appBarColor)
                          : Colors.black,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  NautilusUtil.openUrl('https:' + productEntity.couponShareUrl);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(200),
                  color: Colors.pink.shade100,
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '     分享',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  NautilusUtil.openUrl('https:' + productEntity.couponShareUrl);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(210),
                  color: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '  领券购买',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(28),
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
