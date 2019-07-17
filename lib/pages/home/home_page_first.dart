/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tbk_app/config/service_method.dart';
import 'package:tbk_app/modle/banners_entity.dart';
import 'package:tbk_app/modle/navigator_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/fluro_convert_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entity_factory.dart';
import '../../entity_list_factory.dart';

class HomePageFirst extends StatefulWidget {
  @override
  _HomePageFirstState createState() => _HomePageFirstState();
}

class _HomePageFirstState extends State<HomePageFirst>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = new ScrollController();
  GlobalKey<RefreshFooterState> _refreshFooterState =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _refreshHeaderState =
      GlobalKey<RefreshHeaderState>();
  SwiperController _swiperController;

  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  int page = 1;
  List<ProductListEntity> hotGoodsList = [];
  List<BannersEntity> swiperList = [];
  List<NavigatorEntity> navigatorList = [];
  List recommendList = List(6);
  List flootGoodsList = List(6);
  String adPicture =
      'http://kaze-sora.com/sozai/blog_haru/blog_mitubachi01.jpg';
  String leaderImage =
      'http://kaze-sora.com/sozai/blog_haru/blog_mitubachi01.jpg';
  String picture_address =
      'http://kaze-sora.com/sozai/blog_haru/blog_mitubachi01.jpg';
  String leaderPhone = '17610502953';

  @override
  bool get wantKeepAlive => true;

  int add(int a, int b) {
    return a + b;
  }

  @override
  void initState() {
    _getHotGoods();
    _bannersQueryListForMap();
    _navigatorQueryListForMap();

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

    _swiperController = new SwiperController();
    _swiperController.startAutoplay();
    super.initState();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    _swiperController.stopAutoplay();
    _swiperController.dispose();
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
          _getHotGoods();
        },
        onRefresh: () async {
          getHomePageGoods(page).then((val) {
            List swiper = val['data'];
            setState(() {
              hotGoodsList = swiper;
              page = 1;
            });
          });
        },
        child: ListView(
          controller: _controller,
          children: <Widget>[
            SwiperDiy(
              swiperDataList: swiperList,
              swiperController: _swiperController,
            ),
            TopNavigator(navigatorList: navigatorList),
            AdBanner(adPicture: adPicture),
            LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
            Recommend(recommendList: recommendList),
            FlootTitle(picture_address: picture_address),
            FlootContent(flootGoodsList: flootGoodsList),
            hotTitle,
            ProductList(
              list: hotGoodsList,
              crossAxisCount: 2,
            )
          ],
        ),
      ),
    );
  }

  void _getHotGoods() {
    getHomePageGoods(page).then((val) {
      List<ProductListEntity> list =
          EntityListFactory.generateList<ProductListEntity>(val['data']);

      setState(() {
        hotGoodsList.addAll(list);
        page++;
      });
    });
  }

  void _bannersQueryListForMap() {
    Map<String, Object> map = Map();
    map["pageNo"] = page;
    getHttpRes(
            'banners/queryListForMap', MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        setState(() {
          swiperList =
              EntityListFactory.generateList<BannersEntity>(val['data']);
        });
      }
    });
  }

  void _navigatorQueryListForMap() {
    Map<String, Object> map = Map();
    map["pageNo"] = page;
    getHttpRes('homeNavigator/queryListForMap',
            MapUrlParamsUtils.getUrlParamsByMap(map))
        .then((val) {
      if (val["success"]) {
        setState(() {
          navigatorList =
              EntityListFactory.generateList<NavigatorEntity>(val['data']);
        });
      }
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(1),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text("火爆专区"),
  );
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List<BannersEntity> swiperDataList;
  final SwiperController swiperController;

  SwiperDiy({Key key, this.swiperDataList, this.swiperController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        index: 0,
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index].imageUrl}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        loop: false,
        autoplay: false,
        controller: swiperController,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List<NavigatorEntity> navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(
      BuildContext context, NavigatorEntity navigatorEntity) {
    return InkWell(
      onTap: () {
        print(navigatorEntity.url);

        if (navigatorEntity.isNative == 1) {
          NavigatorUtil.gotransitionPage(
              context,
              Routers.navigatorWebViewPage +
                  "?url=" +
                  navigatorEntity.url +
                  "&title=" +
                  FluroConvertUtils.fluroCnParamsEncode(navigatorEntity.title));
        } else if (navigatorEntity.isNative == 2) {
          NavigatorUtil.gotransitionPage(
            context,
            Routers.navigatorRouterPage +
                "?url=" +
                navigatorEntity.url +
                "&title=" +
                FluroConvertUtils.fluroCnParamsEncode(navigatorEntity.title),
          );
        }
      },
      child: Column(
        children: <Widget>[
          Image.network(
            navigatorEntity.imageUrl,
            width: ScreenUtil().setHeight(95),
          ),
          Text(navigatorEntity.title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
//      height: ScreenUtil().setHeight(20),
      child: Image.network(
        adPicture,
        repeat: ImageRepeat.noRepeat,
      ),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage;

  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'https://www.baidu.com/';
//    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url 不能访问，异常';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        "商品推荐",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 0.5, color: Colors.black12)),
        ),
        child: Column(
          children: <Widget>[
//            Image.network(recommendList[index]['image']),
//            Text('${recommendList[index]['mallPrice']}'),
            Image.network(
                'http://e.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9eac1754f45df39b6003bf3b396.jpg'),
            Text('￥222'),
            Text(
              '￥222',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
        height: ScreenUtil().setHeight(333),
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

class FlootTitle extends StatelessWidget {
  final String picture_address;

  FlootTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picture_address),
    );
  }
}

class FlootContent extends StatelessWidget {
  final List flootGoodsList;

  FlootContent({Key key, this.flootGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods(),
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(flootGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(flootGoodsList[1]),
            _goodsItem(flootGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(flootGoodsList[3]),
        _goodsItem(flootGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map m) {
    return Container(
      width: ScreenUtil().setWidth(375),
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {},
        child: Image.network(
            "http://e.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9eac1754f45df39b6003bf3b396.jpg"),
      ),
    );
  }
}
