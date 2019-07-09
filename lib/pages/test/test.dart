///*
// * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
// */
//
//import 'package:flutter/material.dart';
//
//class Test extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return DefaultTabController(
//      length: 5,
//      child: Scaffold(
//        backgroundColor: Colors.grey[100],
//        appBar: AppBar(
//          leading: IconButton(
//            icon: Icon(Icons.menu),
//            tooltip: 'Navigration',
//            onPressed: () => debugPrint('Navigration Button is pressed.'),
//          ),
//          title: Text('app Bar'),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search),
//              tooltip: 'Search',
//              onPressed: () => debugPrint('search Button is pressed.'),
//            ),
//          ],
//          // 阴影
//          elevation: 0.0,
//          bottom: TabBar(
//            unselectedLabelColor: Colors.black38,
//            indicatorColor: Colors.black54,
//            indicatorSize: TabBarIndicatorSize.label,
//            indicatorWeight: 1.0,
//            tabs: <Widget>[
//              Tab(icon: Icon(Icons.local_florist)),
//              Tab(icon: Icon(Icons.change_history)),
//              Tab(icon: Icon(Icons.directions_bike)),
//              Tab(icon: Icon(Icons.view_quilt)),
//              Tab(icon: Icon(Icons.video_label)),
//            ],
//          ),
//        ),
//        body: TabBarView(
//          children: <Widget>[
//            ListViewDemo(),
//            BasicDemo(),
//            LayoutDemo(),
//            ViewDemo(),
//            SliverDemo(),
//          ],
//        ),
//        drawer: DrawerDemo(                                                                          ),
//        bottomNavigationBar: BottomNavigationBarDemo(),
//
//      ),
//    );
//  }
//}
//
//
//class SliverGridDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return SliverGrid(
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 2,
//        crossAxisSpacing: 8.0,
//        mainAxisSpacing: 8.0,
//        childAspectRatio: 1.0,
//      ),
//      delegate: SliverChildBuilderDelegate(
//            (BuildContext context, int index) {
//          return Container(
//            child: Image.network(
//              posts[index].imgeUrl,
//              fit: BoxFit.cover,
//            ),
//          );
//        },
//        childCount: posts.length,
//      ),
//    );
//  }
//}
//
//class SliverListDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return SliverList(
//      delegate: SliverChildBuilderDelegate(
//            (BuildContext context, int index) {
//          return Padding(
//            padding: EdgeInsets.only(bottom: 32.0),
//            child: Material(
//                borderRadius: BorderRadius.circular(12.0),
//                elevation: 14.0,
//                shadowColor: Colors.green.withOpacity(0.5),
//                child: Stack(
//                  children: <Widget>[
//                    AspectRatio(
//                      aspectRatio: 16 / 9,
//                      child: Image.network(
//                        posts[index].imgeUrl,
//                        fit: BoxFit.cover,
//                      ),
//                    ),
//                    Positioned(
//                      top: 32.0,
//                      left: 32.0,
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            posts[index].title,
//                            style: TextStyle(
//                                fontSize: 20.0, color: Colors.greenAccent),
//                          ),
//                          Text(
//                            posts[index].author,
//                            style: TextStyle(
//                                fontSize: 23.0, color: Colors.greenAccent),
//                          ),
//                        ],
//                      ),
//                    )
//                  ],
//                )),
//          );
//        },
//        childCount: posts.length,
//      ),
//    );
//  }
//}
//
//class SliverDemo extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//            title: Text("liuan"),
//            //  固定在上面 不随着list滚动
//            //  pinned: true,
//// 想下滚动显示 向上 跟随影藏
//            floating: true,
//            // 新写一个面板跟随下滑显示 上滑消失 并伴随渐变动画
//            expandedHeight: 178.0,
//            flexibleSpace: FlexibleSpaceBar(
//                title: Text(
//                  "liuan".toUpperCase(),
//                  style: TextStyle(
//                    fontSize: 15,
//                    letterSpacing: 3.0,
//                    fontWeight: FontWeight.w400,
//                  ),
//                ),
//                background: Image.network(
//                  posts[0].imgeUrl,
//                  fit: BoxFit.cover,
//
//                )
//            ),
//          ),
//          SliverSafeArea(
//            sliver: SliverPadding(
//              padding: EdgeInsets.all(8.0),
//              sliver: SliverListDemo(),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
