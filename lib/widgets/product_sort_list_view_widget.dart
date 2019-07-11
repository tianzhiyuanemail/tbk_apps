import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SliverProductSortListView extends StatelessWidget {
  String sort;
  Function function;

  String s1;
  String s2;

  bool b1 = false;
  bool b2 = false;
  bool b3 = false;

//  排序_des（降序），排序_asc（升序），
//  销量（total_sales）， 人气（tk_total_sales），价格（price）
  String up = "_des";
  String down = "_asc";
  String total_sales = "total_sales";
  String price = "price";

  SliverProductSortListView({Key key, this.sort, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  s1 = total_sales;
                  if (s2 == up){
                    s2 = down;
                  }else {
                    s2 = up;
                  }
                  function(s1 + s2);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("销量"),
                      Icon(
                        s2 == up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  s1 = price;
                  s2 = s2 == up ? down : up;
                  function(s1 + s2);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("价格"),
                      Icon(
                        s2 == up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    s1 = total_sales;
                    s2 = s2 == up ? down : up;
                    function(s1 + s2);
                  },
                  child: Container(
                    child: Icon(
                      s2 == up ? Icons.list : Icons.list,
                      size: 22,
                    ),
                  ))
            ],
          ),
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
