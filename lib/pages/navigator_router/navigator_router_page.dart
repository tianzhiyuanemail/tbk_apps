import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbk_app/modle/material_entity.dart';
import 'package:tbk_app/util/colors_util.dart';
import 'package:tbk_app/util/fluro_navigator_util.dart';

import 'navigator_router_view_page.dart';

class NavigatorRouterPage extends StatefulWidget {
  String url;
  String title;
  List<Materialentity> materialentityList;

  NavigatorRouterPage(this.url, this.title, this.materialentityList);

  @override
  _nineParcelPostState createState() => _nineParcelPostState();
}

// ignore: camel_case_types
class _nineParcelPostState extends State<NavigatorRouterPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(vsync: this, length: widget.materialentityList.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.materialentityList.length,
        child: Scaffold(
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
              title: Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onPressed: () {
                  NavigatorUtil.goBack(context);
                },
              ),
              bottom: widget.materialentityList.length == 1
                  ? PreferredSize(
                      child: Text(""),
                      preferredSize: Size(10, 10),
                    )
                  : PreferredSize(
                      child: TabBars(
                          tabController: tabController,
                          materialentityList: widget.materialentityList),
                      preferredSize: Size(10, 10),
                    ),
            ),
            preferredSize: Size.fromHeight(widget.materialentityList.length == 1?ScreenUtil.screenHeight * 0.02:ScreenUtil.screenHeight * 0.04),
          ),
          body: Container(
            child: widget.materialentityList.length == 1
                ? Text(widget.materialentityList[0].typeName)
                : Container(
                    color: Colors.white,
                    child: new SafeArea(
                      child: TabBarViews(
                          tabController: tabController,
                          materialentityList: widget.materialentityList),
                    ),
                  ),
          ),
        ));
  }
}

class TabBars extends StatelessWidget {
  final TabController tabController;
  final List<Materialentity> materialentityList;

  TabBars(
      {Key key,
      @required this.tabController,
      @required this.materialentityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      height: 35,
      child: TabBar(
        tabs: materialentityList
            .map((tabItem) => Text(tabItem.materialName))
            .toList(),
        isScrollable: true,
        controller: tabController,
        indicatorColor: ColorsUtil.hexToColor(ColorsUtil.appBarColor),
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 15, color: Colors.black45),
        unselectedLabelColor: Colors.black45,
        unselectedLabelStyle: TextStyle(fontSize: 15, color: Colors.black45),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}

class TabBarViews extends StatelessWidget {
  final TabController tabController;
  final List<Materialentity> materialentityList;

  TabBarViews(
      {Key key,
      @required this.tabController,
      @required this.materialentityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewList = materialentityList.map((m) {
      return NavigatorRouterViewPage(m.materialId);
    }).toList();

    return TabBarView(
      children: viewList,
      controller: tabController,
    );
  }
}
