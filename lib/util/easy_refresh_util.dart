/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class EasyRefreshUtil {
  static ClassicsFooter classicsFooter (GlobalKey<RefreshFooterState>
   refreshFooterState ){
     return ClassicsFooter(
       key: refreshFooterState,
       bgColor: Colors.white,
       textColor: Colors.pink,
       moreInfoColor: Colors.pink,
       showMore: true,
       noMoreText: '加载完成',
       moreInfo: '....',
       loadReadyText: '加载中....',
       loadedText: "加载完成",
     );
   }
  static ClassicsHeader classicsHeader (GlobalKey<RefreshHeaderState>
   refreshHeaderState){
     return ClassicsHeader(
       key: refreshHeaderState,
       refreshText: "刷新中....",
       refreshReadyText: "刷新中....",
       refreshingText: "刷新中....",
       refreshedText: "加载完成",
       bgColor: Colors.white,
       textColor: Colors.pink,
       moreInfoColor: Colors.pink,
       refreshHeight: 90.0,
//    isFloat: false,
//    showMore: false,
       moreInfo: "....",
     );
   }
}
