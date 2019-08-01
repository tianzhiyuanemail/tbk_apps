import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/navigator_entity.dart';
import 'package:tbk_app/modle/advertisement_entity.dart';
import 'package:tbk_app/modle/product_entity.dart';
import 'package:tbk_app/modle/product_recommend_entity.dart';
import 'package:tbk_app/modle/banners_entity.dart';
import 'package:tbk_app/modle/cate_entity.dart';
import 'package:tbk_app/modle/home_navigator_entity.dart';

import 'modle/material_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ProductListEntity") {
      return ProductListEntity.fromJson(json) as T;
    } else if (T.toString() == "NavigatorEntity") {
      return NavigatorEntity.fromJson(json) as T;
    } else if (T.toString() == "AdvertisementEntity") {
      return AdvertisementEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductEntity") {
      return ProductEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductRecommendEntity") {
      return ProductRecommendEntity.fromJson(json) as T;
    } else if (T.toString() == "BannersEntity") {
      return BannersEntity.fromJson(json) as T;
    } else if (T.toString() == "CateEntity") {
      return CateEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeNavigatorEntity") {
      return HomeNavigatorEntity.fromJson(json) as T;
    } else if (T.toString() == "Materialentity") {
      return Materialentity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}