/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tbk_app/config/loading.dart';
import 'package:tbk_app/modle/advertisement_entity.dart';
import 'package:tbk_app/modle/banners_entity.dart';
import 'package:tbk_app/modle/home_navigator_entity.dart';
import 'package:tbk_app/modle/product.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/product_recommend_entity.dart';
import 'package:tbk_app/res/colors.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/cache_network_image_util.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/util/res_list_util.dart';
import 'package:tbk_app/widgets/animation_headlines.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/menue.dart';
import 'package:tbk_app/widgets/my_easy_refresh.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:tbk_app/widgets/recommed.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entity_list_factory.dart';

class HomePageFirst extends StatefulWidget {
  @override
  _HomePageFirstState createState() => _HomePageFirstState();
}

class _HomePageFirstState extends State<HomePageFirst>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  ScrollController _controller = new ScrollController();
  SwiperController _swiperController = new SwiperController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮
  bool noMore = false;

  int page = 1;
  List<ProductListEntity> hotGoodsList = [];
  List<BannersEntity> swiperList = [];
  List<AdvertisementEntity> adList = [];
  List<HomeNavigatorEntity> navigatorList = [];
  List<ProductRecommendEntity> recommendList = []; // 今日推荐商品

  AnimationController _animationController;

  String get hoursString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inHours)..toString().padLeft(2, '0')}';
  }

  String get minutesString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  String get secondsString {
    Duration duration =
        _animationController.duration * _animationController.value;
    return '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  List headlines = [
    'MT大白洗碗机测评：用了就再也回不去了',
    '我与MT大白洗碗机的蜗居生活',
    '太平洋电脑网每日早报，10月25日份，请查收',
    '新版手机天猫上线！逛街时可以摇出红包！赶紧更新吧',
    '天猫双11手机&配件预售会场满减大促'
  ];

  var recommendJson = {
    "title": "新品推荐",
    'items': [
      {
        "bg_color": "#fcf8f4",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/tfs/TB1rCjhUyLaK1RjSZFxXXamPFXa-345-345.png_400x400Q50s50.jpg_.webp",
        "subtitle": "抢100元卷",
        "subtitle_color": "#fd4f51",
        "tag_color": "#d8996f",
        "title": "聚划算",
        "title_color": "#333333"
      },
      {
        "bg_color": "#fcf8f4",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/tfs/TB1Ekx_UwHqK1RjSZFkXXX.WFXa-345-297.png_400x400Q50s50.jpg_.webp",
        "subtitle": "现金红包",
        "subtitle_color": "#ff7525",
        "tag_color": "#d8996f",
        "tag_img": "",
        "tag_mode": 1,
        "tag_text": "",
        "title": "",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i3/2459495011/TB28AUmDNGYBuNjy0FnXXX5lpXa_!!2459495011.png_400x400Q50s50.jpg_.webp",
        "subtitle": "抢直播福利",
        "subtitle_color": "#ff4d7c",
        "tag_color": "#d8996f",
        "title": "淘宝直播",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i2/6000000006286/TB2y0_SGxGYBuNjy0FnXXX5lpXa_!!6000000006286-2-at.png_440x440Q50s50.jpg_.webp",
        "subtitle": "",
        "subtitle_color": "#fd4f51",
        "tag_color": "#d8996f",
        "title": "",
        "title_color": "#333333"
      },
      //
      {
        "bg_color": "#fcf8f4",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i1/52660971/O1CN011J2l2EZDLLw1gsZ_!!52660971.png_400x400Q50s50.jpg_.webp",
        "subtitle": "限时半价",
        "subtitle_color": "#f8003d",
        "tag_color": "#d8996f",
        "title": "淘抢购",
        "title_color": "#333333"
      },
      {
        "bg_color": "#fcf8f4",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i2/229042948/TB2f9PupqmWBuNjy1XaXXXCbXXa_!!229042948.png_400x400Q50s50.jpg_.webp",
        "subtitle": "9.9包邮",
        "subtitle_color": "#fd4e0e",
        "tag_color": "#d8996f",
        "tag_img": "",
        "tag_mode": 1,
        "tag_text": "",
        "title": "天天特价",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i1/818931597/TB2POGYdQSWBuNjSszdXXbeSpXa_!!818931597.png_400x400Q50s50.jpg_.webp",
        "subtitle": "发现世间好物",
        "subtitle_color": "#56beff",
        "tag_color": "#d8996f",
        "title": "有好货",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i1/1014281128/O1CN01x1KqZr1KCfHMTYfEB_!!1014281128.png_400x400Q50s50.jpg_.webp",
        "subtitle": "",
        "subtitle_color": "#fd4f51",
        "tag_color": "#d8996f",
        "title": "",
        "title_color": "#333333"
      },
      //
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i3/2695817590/O1CN01mJlWJA25wGcZYDdwk_!!2695817590.png_400x400Q50s50.jpg_.webp",
        "subtitle": "挖深藏的店",
        "subtitle_color": "#f8a507",
        "tag_color": "#d8996f",
        "title": "每日好店",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i1/420722466/O1CN011U5T9psOfc6QV8w_!!420722466.png_400x400Q50s50.jpg_.webp",
        "subtitle": "",
        "subtitle_color": "#fd4f51",
        "tag_color": "#d8996f",
        "tag_img": "",
        "tag_mode": 1,
        "tag_text": "",
        "title": "",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i3/2090142745/O1CN01dnOm5n1W9FiYxo7JT_!!2090142745.png_400x400Q50s50.jpg_.webp",
        "subtitle": "抢初夏必买",
        "subtitle_color": "#fe5f08",
        "tag_color": "#d8996f",
        "title": "哇哦视频",
        "title_color": "#333333"
      },
      {
        "bg_color": "#ffffff",
        "jump_url": "",
        "pic_url":
            "https://img.alicdn.com/imgextra/i4/619789678/TB2JWZrX9f8F1Jjy0FeXXallpXa_!!619789678.png_400x400Q50s50.jpg_.webp",
        "subtitle": "",
        "subtitle_color": "#fd4f51",
        "tag_color": "#d8996f",
        "title": "",
        "title_color": "#333333"
      },
      //
    ],
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    //倒计时
    _animationController = AnimationController(
        vsync: this, duration: Duration(hours: 10, minutes: 30, seconds: 0));
    _animationController.reverse(
        from: _animationController.value == 0.0
            ? 1.0
            : _animationController.value);

    _onRefresh();
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

    _swiperController.startAutoplay();
    super.initState();
  }

  @override
  void dispose() {

    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    _easyRefreshController.dispose();
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Loading.ctx = context; // 注入context
    return Scaffold(
      floatingActionButton:
          BackTopButton(controller: _controller, showToTopBtn: showToTopBtn),
      body: MyEasyRefresh(
        easyRefreshController: _easyRefreshController,
        onLoad: () async {
          _easyRefreshController.finishLoad(noMore: noMore);
          _loadMore();
        },
        onRefresh: () async {
          _easyRefreshController.resetLoadState();
        },
        child: CustomScrollView(
          controller: _controller,
          reverse: false,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _buildSwiperDiy(),
            ),
            SliverToBoxAdapter(
              child: _buildSwiperButtonWidget(),
            ),
            SliverToBoxAdapter(
              child: _buildRecommendedCard(),
            ),
            SliverToBoxAdapter(
              child: _buildAdvertisingWidget(),
            ),
            SliverToBoxAdapter(
              child: Recommend(recommendList: recommendList),
            ),
            SliverToBoxAdapter(
              child: hotTitle,
            ),
//            SliverProductList(list: hotGoodsList, crossAxisCount: 1),
          ],
        ),
      ),
    );
  }

  /// 特惠
  void _loadMore() {
    Map<String, Object> map = Map();
    map["materialId"] = 4094;
    map["pageNo"] = page;

    HttpUtil()
        .get('choiceMaterial', parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        List<ProductListEntity> list =
            EntityListFactory.generateList<ProductListEntity>(val['data']);

//        ResListEntity resListEntity =
//            ResListUtil.buildResList(hotGoodsList, list, page, noMore);
//        setState(() {
//          print(val["message"]);
//          hotGoodsList = resListEntity.list;
//          noMore = resListEntity.noMore;
//          page = resListEntity.page;
//        });
      }
    });
  }

  /// 特惠
  void _onRefresh() {
    setState(() {
      page = 1;
    });
    _loadMore();
    _bannersQueryListForMap();
    _navigatorQueryListForMap();
    _getRecommendList();
    _getAdvertisements();
  }

  /// 广告
  void _getAdvertisements() {
    HttpUtil().get('advertisements').then((val) {
      if (val["success"]) {
        setState(() {
          adList =
              EntityListFactory.generateList<AdvertisementEntity>(val['data']);
        });
      }
    });
  }

  /// 首页大分类
  void _getRecommendList() {
    HttpUtil().get('productRecommends').then((val) {
      if (val["success"]) {
        setState(() {
          recommendList =
              EntityListFactory.generateList<ProductRecommendEntity>(
                  val['data']);
        });
      }
    });
  }

  /// 轮播图
  void _bannersQueryListForMap() {
    Map<String, Object> map = Map();
    map["pageNo"] = page;
    HttpUtil()
        .get('banners/queryListForMap',
            parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        setState(() {
          swiperList =
              EntityListFactory.generateList<BannersEntity>(val['data']);
        });
      }
    });
  }

  // 今日商品推荐
  void _navigatorQueryListForMap() {
    Map<String, Object> map = Map();
    map["pageNo"] = page;
    HttpUtil()
        .get('homeNavigator/queryListForMap',
            parms: MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        setState(() {
          navigatorList =
              EntityListFactory.generateList<HomeNavigatorEntity>(val['data']);
        });
      }
    });
  }

  ///      widget  ////
  /// 首页轮播组件编写
  Widget _buildSwiperDiy() {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        index: 0,
        itemBuilder: (BuildContext context, int index) {
          return loadNetworkImage("${swiperList[index].imageUrl}",
              fit: BoxFit.fill);
        },
        itemCount: swiperList.length,
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
        loop: false,
        autoplay: false,
        controller: _swiperController,
      ),
    );
  }

  /// 按钮导航
  Widget _buildSwiperButtonWidget() {
    return Container(
      height: ScreenUtil().setWidth(140) * 2 + 15,
      child: Swiper(
        /// 初始的时候下标位置
        index: 0,

        /// 无限轮播模式开关
        loop: true,
        itemBuilder: (context, index) {
          List<HomeNavigatorEntity> data = [];
          for (var i = (index * 2) * 5; i < (index * 2) * 5 + 5; ++i) {
            //0-4,5-9,10-14,15-19
            if (i >= navigatorList.length) {
              break;
            }
            data.add(navigatorList[i]);
          }
          List<HomeNavigatorEntity> data1 = [];
          for (var i = (index * 2 + 1) * 5; i < (index * 2 + 1) * 5 + 5; ++i) {
            //0-4,5-9,10-14,15-19
            if (i >= navigatorList.length) {
              break;
            }
            data1.add(navigatorList[i]);
          }

          return Column(
            children: <Widget>[
              HomeMenueWidget(
                data: data,
                fontColor: "#555666",
                bgurl: "",
              ),
              HomeMenueWidget(
                data: data1,
                fontColor: "#555666",
                bgurl: "",
              ),
            ],
          );
        },
        itemCount: (navigatorList.length / 10).toInt() +
            (navigatorList.length % 10 > 0 ? 1 : 0),

        /// 设置 new SwiperPagination() 展示默认分页指示器
        pagination: new SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: RectSwiperPaginationBuilder(
                color: Color(0xFFd3d7de),
                activeColor: Theme.of(context).primaryColor,
                size: Size(18, 3),
                activeSize: Size(18, 3),
                space: 0)),

        /// 设置 new SwiperControl() 展示默认分页按钮
        // control: SwiperControl(),
        /// 自动播放开关.
        autoplay: false,

        /// 动画时间，单位是毫秒
        duration: 300,

        /// 当用户点击某个轮播的时候调用
        onTap: (index) {
          print("你点击了第$index个");
        },

        /// 滚动方向，设置为Axis.vertical如果需要垂直滚动
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /// 中间广告位置 一大坨
  Widget _buildRecommendedCard() {
    Positioned unReadMsgCountText = Positioned(
      child: Container(
//        width: 10.0,
//        height: 10.0,
//        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20 / 2.0), color: Color(0xffff3e3e)),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, Widget child) {
              return Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      color: Colors.red,
                      child: Text(
                        hoursString,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      color: Colors.red,
                      child: Text(
                        minutesString,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      color: Colors.red,
                      child: Text(
                        secondsString,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
      left: 55,
      top: 10,
    );

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
//          elevation: 20.0,
        //设置shape，这里设置成了R角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
        clipBehavior: Clip.antiAlias,
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    RecommendFloor(ProductListModel.fromJson(recommendJson)),
                    unReadMsgCountText,
                  ],
                ),
                Container(
                    width: ScreenUtil.screenWidth,
                    height: 0.7,
                    color: GZXColors.mainBackgroundColor),
                AnimationHeadlinesWidget(headlines: headlines),
              ],
            )),
      ),
    );
  }

  /// 轮播导航
  Widget _buildAdvertisingWidget() {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 10),
      height: 80,
      child: ConstrainedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Swiper(
            index: 0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  String s = Uri.encodeComponent(adList[0]?.url);
                  NavigatorUtil.push(
                      context,
                      Routers.navigatorWebViewPage +
                          "?url=${s}&title=" +
                          FluroConvertUtils.fluroCnParamsEncode("测试用"));
                },
                child: loadNetworkImage("${adList[index].imageUrl}",
                    fit: BoxFit.fill),
              );
            },
            itemCount: adList.length,
            loop: false,
            autoplay: false,
            duration: 300,
            autoplayDelay: 5000,
            controller: _swiperController,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                  color: Colors.transparent, // 其他点的颜色
                  activeColor: Colors.transparent, // 当前点的颜色
                  space: 2, // 点与点之间的距离
                  activeSize: 20 // 当前点的大小
                  ),
            ),
          ),
        ),
        constraints: new BoxConstraints.expand(),
      ),
    );
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10, bottom: 0),
    padding: EdgeInsets.only(top: 5, bottom: 5),
    alignment: Alignment.center,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          "————",
          style: TextStyle(color: Colors.pink),
        ),
        Text(
          "为你推荐",
          style: TextStyle(color: Colors.pink),
        ),
        Text(
          "————",
          style: TextStyle(color: Colors.pink),
        ),
      ],
    ),
  );
}

/// 商品推荐
class Recommend extends StatelessWidget {
  final List<ProductRecommendEntity> recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/images/home_page_first/juzi.png",
            fit: BoxFit.fill,
            width: 20,
          ),
          Text(
            "  商品推荐",
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }

  Widget _item(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.push(context,
            "${Routers.detailsPage}?id=${recommendList[index].productId}");
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            loadNetworkImage(recommendList[index].imageUrl),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 5),
                  padding: EdgeInsets.only(left: 2, right: 2),
                  color: Colors.pink,
                  child: Text(
                    '${recommendList[index].hotType}',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2, bottom: 2),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: Colors.pink),
                  ),
                  child: Text(
                    '${recommendList[index].couponPrice}元券',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '￥${recommendList[index].afterCouponPrice}',
                  style: TextStyle(fontSize: 12, color: Colors.pink),
                ),
                Text(
                  '￥${recommendList[index].zkFinalPrice}',
                  style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _recommendList(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(333),
        margin: EdgeInsets.only(top: 0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index, context);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(context),
        ],
      ),
    );
  }
}
