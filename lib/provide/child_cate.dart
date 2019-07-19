
import 'package:flutter/material.dart';
import 'package:tbk_app/modle/cate_entity.dart';

class ChildCate with ChangeNotifier {
  List<CateEntity> chileCate = [];


  //点击大类时更换
  getChildCate (List list){
    chileCate = list;
    notifyListeners();
  }

}
