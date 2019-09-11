import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tbk_app/config/haodanku_url.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/haodanku/brand_item_list_entity.dart';
import 'package:tbk_app/modle/haodanku/brand_subject_item_list_entity.dart';
import 'package:tbk_app/modle/haodanku/brand_today_item_list_entity.dart';
import 'package:tbk_app/router/routers.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/image_utils.dart';
import 'package:tbk_app/widgets/MyScaffold.dart';
import 'package:tbk_app/widgets/app_bar.dart';
import 'package:tbk_app/widgets/my_easy_refresh.dart';

import '../../entity_list_factory.dart';

class BrandPage extends StatefulWidget {
  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage>
    with AutomaticKeepAliveClientMixin {
  /// 列表相关类
  ScrollController _scrollController;
  EasyRefreshController _easyRefreshController;

  List<BrandItemListEntity> brandItemList = [];
  List<BrandSubjectItemListEntity> brandSubjectItemList = [];
  List<BrandTodayItemListEntity> brandTodayItemList = [];

  int page = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController = new ScrollController();
    _easyRefreshController = EasyRefreshController();

    super.initState();
    _brandGetList();
  }

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: MyAppBar(
        centerTitle: "品牌闪购",
      ),
      backTop: true,
      scrollController: _scrollController,
      body: false
          ? Container(
              alignment: Alignment.center,
              height: ScreenUtil().setHeight(750),
              child: CircularProgressIndicator(),
            )
          : MyEasyRefresh(
              easyRefreshController: _easyRefreshController,
              onRefresh: () async {
                _easyRefreshController.resetLoadState();
//          _brandGetList(reset: true);
              },
              onLoad: () async {
//          _easyRefreshController.finishLoad(noMore: _listEntity.hasMore);
//          _getList(reset: false);
              },
              child: CustomScrollView(
                controller: _scrollController,
                reverse: false,
                slivers: <Widget>[
//            SliverToBoxAdapter(
//              child: _buildSwiperDiy(),
//            ),

//            SliverToBoxAdapter(
//              child: _buildRecommend(),
//            ),
                  _buildBrandItem(),
                ],
              ),
            ),
    );
  }

  /// 首页轮播组件编写
  Widget _buildSwiperDiy() {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Swiper(
        index: 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(
                    "${brandSubjectItemList[index].brandImage}"), // 图片数组
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        itemCount: brandSubjectItemList.length,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: Colors.pink,
              space: 8,
              activeSize: 8,
              size: 8),
        ),
        loop: true,
        autoplay: true,
        scale: 0.8,
      ),
    );
  }

  /// 商品推荐
//  Widget _buildRecommend() {
//    return Container(
//        height: ScreenUtil().setHeight(333),
//        margin: EdgeInsets.only(top: 0),
//        child: ListView.builder(
//          scrollDirection: Axis.horizontal,
//          itemCount: brandTodayItemList.length,
//          itemBuilder: (context, index) {
//            return InkWell(
//              onTap: () {
//                NavigatorUtil.push(context,
//                    "${Routers.detailsPage}?id=${obj.itemid}");
//              },
//              child: Container(
//                height: ScreenUtil().setHeight(330),
//                width: ScreenUtil().setWidth(250),
//                padding: EdgeInsets.all(8),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                ),
//                child: Column(
//                  children: <Widget>[
//                    loadNetworkImage(obj.itempic),
//                    Row(
//                      children: <Widget>[
//                        Container(
//                          margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 5),
//                          padding: EdgeInsets.only(left: 2, right: 2),
//                          color: Colors.pink,
//                          child: Text(
//                            '${obj.itemtitle}',
//                            style: TextStyle(fontSize: 10, color: Colors.white),
//                          ),
//                        ),
//                        Container(
//                          margin: EdgeInsets.only(top: 2, bottom: 2),
//                          padding: EdgeInsets.only(left: 10, right: 10),
//                          decoration: BoxDecoration(
//                            color: Colors.white,
//                            border: Border.all(width: 0.5, color: Colors.pink),
//                          ),
//                          child: Text(
//                            '${obj.itemid}元券',
//                            style: TextStyle(fontSize: 10),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          '￥${obj.itemprice}',
//                          style: TextStyle(fontSize: 12, color: Colors.pink),
//                        ),
//                        Text(
//                          '￥${obj.itemprice}',
//                          style: TextStyle(
//                              fontSize: 12,
//                              decoration: TextDecoration.lineThrough,
//                              color: Colors.grey),
//                        ),
//                      ],
//                    )
//                  ],
//                ),
//              ),
//            );
//          },
//        ));
//  }

  /// 品牌列表
  Widget _buildBrandItem() {
    return Container(
        child: SliverGrid(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        childAspectRatio: 1 / 1,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(26.0)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: loadNetworkImage(brandItemList[index].brandLogo,
                      width: ScreenUtil.screenHeightDp,
                      height: ScreenUtil().setWidth(350),
//                    fit: BoxFit.fill
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: brandItemList[index].item.map((obj){
                      return InkWell(
                        onTap: () {
                          NavigatorUtil.push(context,
                              "${Routers.detailsPage}?id=${obj.itemid}");
                        },
                        child: Container(
                          height: ScreenUtil().setHeight(360),
                          width: ScreenUtil().setWidth(240),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              loadNetworkImage(obj.itempic),
                              Container(
                                margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 5),
                                padding: EdgeInsets.only(left: 2, right: 2),
                                color: Colors.pink,
                                child: Text(
                                  '${obj.itemtitle}',
                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '￥${obj.itemprice}',
                                    style: TextStyle(fontSize: 12, color: Colors.pink),
                                  ),
                                  Text(
                                    '￥${obj.itemprice}',
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
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
        childCount: brandItemList.length,
      ),
    ));
  }

  void _brandGetList() {
    HttpUtil()
        .getAllPath("${HaoDanKuUrl.brand}/back/20/min_id/${page}")
        .then((val) {
      Map map = json.decode(val);
      if (map["code"] == 1) {
        setState(() {
          brandItemList =
              EntityListFactory.generateList<BrandItemListEntity>(map['data']);
          brandSubjectItemList =
              EntityListFactory.generateList<BrandSubjectItemListEntity>(
                  map['subjectitems']);
          brandTodayItemList =
              EntityListFactory.generateList<BrandTodayItemListEntity>(
                  map['todayrecommend']);
        });
      } else {}
    });
  }
}
