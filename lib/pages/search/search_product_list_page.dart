/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/sort_modle.dart';
import 'package:tbk_app/res/resources.dart';
import 'package:tbk_app/router/application.dart';
import 'package:tbk_app/util/easy_refresh_util.dart';
import 'package:tbk_app/util/http_util.dart';
import 'package:tbk_app/util/map_url_params_utils.dart';
import 'package:tbk_app/widgets/back_top_widget.dart';
import 'package:tbk_app/widgets/product_list_view_widget.dart';
import 'package:tbk_app/widgets/product_silvrs_sort_static_bar_widget.dart';

import '../../entity_list_factory.dart';

// ignore: must_be_immutable
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
  List<ProductListEntity> goodsList = [];
  int page = 1;
  /// 排序相关
  SortModle _sortModle = new SortModle();
  String searchText;


  @override
  void initState() {
    _getGoods();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
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

    searchText = widget.searchText;
    super.initState();
  }

  void _getGoods() {

    Map<String, Object> map  = Map();
    map["query"] = searchText == null ? widget.searchText : searchText;
    map["pageNo"] = page;
    map["sort"] = _sortModle.s1+_sortModle.s2;

    HttpUtil().get('getProductList',parms: MapUrlParamsUtils.getUrlParamsByMap(map)).then((val) {
      if(val["success"]){
        List<ProductListEntity> list = EntityListFactory.generateList<ProductListEntity>(val['data']);
        setState(() {
          if (page == 1){
            goodsList = list;
          }else{
            goodsList.addAll(list);
          }
          page++;
        });
      }else{

        setState(() {
          print(val["message"]);
          goodsList = List();
          page  = 1;
        });
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.maybePop(context);
          },
          padding: const EdgeInsets.all(12.0),
          icon: Image.asset(
            "assets/images/sys/ic_back_black.png",
            color: Colors.black,
            width: 25,
          ),
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
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: TextField(
            onSubmitted: (val) {
              this.setState(() {
                this.searchText = val;
                this.page = 1;
                _getGoods();
              });
            },
            controller: TextEditingController(text: this.searchText),
            autofocus: false,
            maxLines: 1,
            keyboardType: TextInputType.text,
            cursorColor: Colours.text_gray,
            keyboardAppearance: Brightness.light,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 8.0),
                border: InputBorder.none,
                prefixIcon: Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: Color.fromARGB(255, 128, 128, 128),
                  ),
                )),
            style: TextStyles.textNormal16,
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
          setState(() {
            page = 1;
          });
          _getGoods();
        },
        autoLoad: true,
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverSortStaticyBar.buildStickyBar(_sortModle,
                (SortModle sortModle) {
              setState(() {
                _sortModle = sortModle;
                page = 1;
              });
              _getGoods();
            }),
            SliverProductList(
              list: goodsList,
              crossAxisCount: _sortModle.crossAxisCount,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    ///为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }
}
