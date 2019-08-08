
import 'package:flutter/material.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';

class UserInfoProvide with ChangeNotifier {

  UserInfoEntity userInfoEntity =  new UserInfoEntity();

  //点击大类时更换
  buildUserInfo (UserInfoEntity userInfo){
    userInfoEntity = userInfo;
    notifyListeners();
  }

}
