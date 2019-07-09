import 'package:flutter/material.dart';
import 'package:tbk_app/pages/home/hom_page_other.dart';
import 'package:tbk_app/pages/home/home_page_first.dart';

class FlutterTabBarView extends StatelessWidget {
  final TabController tabController;
  final List titleList;

  FlutterTabBarView({Key key, @required this.tabController,@required this.titleList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewList = [];

    viewList =  titleList.asMap().keys.map((key){
      if (key == 0){
        return HomePageFirst();
      }else if(key == 1){
        return Page2();
      }else{
        return HomePageOther();
      }
    }).toList();


    return TabBarView(
      children: viewList,
      controller: tabController,
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page1');

    return Center(
      child: Text('Page1'),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page2');
    return Center(
      child: Text('Page2'),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page3');
    return Center(
      child: Text('Page3'),
    );
  }
}

class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page4');
    return Center(
      child: Text('Page4'),
    );
  }
}

class Page5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page5');
    return Center(
      child: Text('Page5'),
    );
  }
}
