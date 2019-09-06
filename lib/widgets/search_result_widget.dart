import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/res/gzx_style.dart';
import 'package:tbk_app/util/common_utils.dart';

/// todo 淘宝列表
class SearchResultWidget extends StatelessWidget {
  final bool single;
  final bool hasMore;
  final List<ProductListEntity> list;
  final ValueChanged<String> onItemTap;
  final VoidCallback getNextPage;
  BuildContext _context;
  ScrollController scrollController;

  SearchResultWidget(this.list,
      {Key key,
      this.onItemTap,
      this.getNextPage,
      this.single = false,
      this.hasMore = true,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return list.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : single
            ? Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: productGridView(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: productListView(),
              );
  }

  Widget productListView() => ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length,
        itemExtent: ScreenUtil().setSp(200),
        itemBuilder: (BuildContext context, int i) {
          ProductListEntity item = list[i];
          if ((i + 3) == list.length && hasMore) {
            print(
                'SearchResultListWidget.build next page,current data count ${list.length}');
            getNextPage();
          }
          return Container(
            color: GZXColors.searchAppBarBgColor,
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(5),
                right: ScreenUtil().setWidth(10)),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 0),
                    fadeOutDuration: Duration(milliseconds: 0),
                    fit: BoxFit.fill,
                    imageUrl: item.pictUrl,
                    width: ScreenUtil().setWidth(180),
                    height: ScreenUtil().setWidth(180),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: GZXColors.divideLineColor))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: <Widget>[
                          item.couponInfo == null
                              ? SizedBox()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, top: 0, right: 0, bottom: 0),
                                  child: Text(
                                    item.couponInfo,
                                    style: TextStyle(
                                        color: Color(0xFFff692d), fontSize: 10),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      border: Border.all(
                                          width: 1, color: Color(0xFFff692d))),
                                ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, top: 0, right: 0, bottom: 0),
                            child: Text(
                              '包邮',
                              style: TextStyle(
                                  color: Color(0xFFfebe35), fontSize: 10),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                border: Border.all(
                                    width: 1, color: Color(0xFFffd589))),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '￥',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xFFff5410)),
                          ),
                          Text(
                            '${CommonUtils.removeDecimalZeroFormat(double.parse(item.zkFinalPrice))}',
//                          '27.5',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFff5410)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              '${item.couponInfo}人评价',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF979896)),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  '${item.shopTitle}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GZXConstant
                                      .searchResultItemCommentCountStyle,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text('进店', style: TextStyle(fontSize: 12)),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.more_horiz,
                              size: 15,
                              color: Color(0xFF979896),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      );

  Widget productGridView() => GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(_context).orientation == Orientation.portrait ? 2 : 3,
        // 左右间隔
        crossAxisSpacing: 8,
        // 上下间隔
        mainAxisSpacing: 8,
        //宽高比 默认1
        childAspectRatio: 7 / 10,
      ),
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var product = list[index];
        if ((index + 4) == list.length && hasMore) {
          print(
              'SearchResultGridViewWidget.productGrid next page,current data count ${list.length},current index $index');
          getNextPage();
        }
        return Container(
            child: Padding(
          padding: const EdgeInsets.all(0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ConstrainedBox(
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      fit: BoxFit.fill,
                      imageUrl: product.pictUrl,
                    ),
                    constraints: new BoxConstraints.expand(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, top: 0, right: 8, bottom: 0),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: <Widget>[
                    product.couponInfo == null
                        ? SizedBox()
                        : Container(
                            margin: const EdgeInsets.only(
                                left: 8, top: 0, right: 0, bottom: 0),
                            child: Text(
                              product.couponInfo,
                              style: TextStyle(
                                  color: Color(0xFFff692d), fontSize: 10),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                border: Border.all(
                                    width: 1, color: Color(0xFFff692d))),
                          ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 8, top: 0, right: 0, bottom: 0),
                      child: Text(
                        '包邮',
                        style:
                            TextStyle(color: Color(0xFFfebe35), fontSize: 10),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border:
                              Border.all(width: 1, color: Color(0xFFffd589))),
                    )
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '￥',
                      style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
                    ),
                    Text(
                      '${CommonUtils.removeDecimalZeroFormat(double.parse(product.zkFinalPrice))}',
//                          '27.5',
                      style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '${product.couponAmount}人评价',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF979896)),
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      size: 15,
                      color: Color(0xFF979896),
                    ),
                    SizedBox(
                      width: 8,
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        ));
      });
}
