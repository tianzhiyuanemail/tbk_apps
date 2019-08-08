import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/util/sp_util.dart';

import '../entity_factory.dart';
import 'fluro_convert_util.dart';

///数据库相关的工具
class SharedPreferenceUtil {
  static const String ACCOUNT_NUMBER = "user";

  ///删掉单个账号
  static void delUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(ACCOUNT_NUMBER);
  }

  ///保存账号
  static void saveUser(UserInfoEntity user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(ACCOUNT_NUMBER, FluroConvertUtils.object2string(user));
  }

  ///获取已经登录的账号
  static Future<UserInfoEntity> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String  str =  sp.get(ACCOUNT_NUMBER);
    var json =  FluroConvertUtils.string2map(str);
    UserInfoEntity userInfoEntity =  EntityFactory.generateOBJ<UserInfoEntity>(json);
    return userInfoEntity;
  }
  static  UserInfoEntity getUsers()  {
    UserInfoEntity userInfoEntity;

       String  str =  SpUtil.getString(ACCOUNT_NUMBER);
       if(str != null && str != ''){
         var json =  FluroConvertUtils.string2map(str);
         userInfoEntity =  EntityFactory.generateOBJ<UserInfoEntity>(json);
       }

        return userInfoEntity;
  }


}