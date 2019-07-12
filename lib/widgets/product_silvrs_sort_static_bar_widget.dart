import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tbk_app/modle/sort_modle.dart';

class SliverSortStaticyBar {
  /// 固定导航
  static Widget buildStickyBar(SortModle _sortModle, Function function) {
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
                  _sortModle.s1 = _sortModle.total_sales;
                  _sortModle.s2 = _sortModle.s2 == _sortModle.up
                      ? _sortModle.down
                      : _sortModle.up;
                  function(_sortModle);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "销量",
                        style: TextStyle(
                            color: _sortModle.s1 == _sortModle.total_sales
                                ? Colors.redAccent
                                : null),
                      ),
                      Icon(
                        (_sortModle.s1 + _sortModle.s2) ==
                            _sortModle.total_sales + _sortModle.up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _sortModle.s1 == _sortModle.total_sales
                            ? Colors.redAccent
                            : null,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _sortModle.s1 = _sortModle.price;
                  _sortModle.s2 = _sortModle.s2 == _sortModle.up
                      ? _sortModle.down
                      : _sortModle.up;
                  function(_sortModle);
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "价格",
                        style: TextStyle(
                            color: _sortModle.s1 == _sortModle.price
                                ? Colors.redAccent
                                : null),
                      ),
                      Icon(
                        _sortModle.s1 + _sortModle.s2 ==
                            _sortModle.price + _sortModle.up
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _sortModle.s1 == _sortModle.price
                            ? Colors.redAccent
                            : null,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    _sortModle.crossAxisCount =
                    _sortModle.crossAxisCount == 1 ? 2 : 1;
                    function(_sortModle);
                  },
                  child: Container(
                    child: Icon(
                      _sortModle.crossAxisCount == 1 ? Icons.list : Icons.sort,
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


