
import 'package:flutter/material.dart';

class ChildCate with ChangeNotifier {
  List chileCate = [];


  //点击大类时更换
  getChildCate (List list){
    chileCate = list;
    notifyListeners();
  }

}
