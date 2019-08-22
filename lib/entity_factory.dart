import 'package:tbk_app/modle/upload_file_entity.dart';
import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/navigator_entity.dart';
import 'package:tbk_app/modle/advertisement_entity.dart';
import 'package:tbk_app/modle/product_entity.dart';
import 'package:tbk_app/modle/home_cate_entity.dart';
import 'package:tbk_app/modle/product_recommend_entity.dart';
import 'package:tbk_app/modle/banners_entity.dart';
import 'package:tbk_app/modle/user_info_entity.dart';
import 'package:tbk_app/modle/material_entity.dart';
import 'package:tbk_app/modle/taobao_user_entity.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/home_navigator_entity.dart';
import 'package:tbk_app/modle/sms_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "UploadFileEntity") {
      return UploadFileEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductListEntity") {
      return ProductListEntity.fromJson(json) as T;
    } else if (T.toString() == "NavigatorEntity") {
      return NavigatorEntity.fromJson(json) as T;
    } else if (T.toString() == "AdvertisementEntity") {
      return AdvertisementEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductEntity") {
      return ProductEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeCateEntity") {
      return HomeCateEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductRecommendEntity") {
      return ProductRecommendEntity.fromJson(json) as T;
    } else if (T.toString() == "BannersEntity") {
      return BannersEntity.fromJson(json) as T;
    } else if (T.toString() == "UserInfoEntity") {
      return UserInfoEntity.fromJson(json) as T;
    } else if (T.toString() == "Materialentity") {
      return Materialentity.fromJson(json) as T;
    } else if (T.toString() == "TaobaoUserEntity") {
      return TaobaoUserEntity.fromJson(json) as T;
    } else if (T.toString() == "CateEntity") {
      return CateEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeNavigatorEntity") {
      return HomeNavigatorEntity.fromJson(json) as T;
    } else if (T.toString() == "SmsEntity") {
      return SmsEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}