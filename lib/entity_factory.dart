import 'package:tbk_app/modle/product_list_entity.dart';
import 'package:tbk_app/modle/navigator_entity.dart';
import 'package:tbk_app/modle/product_entity.dart';
import 'package:tbk_app/modle/banners_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ProductListEntity") {
      return ProductListEntity.fromJson(json) as T;
    } else if (T.toString() == "NavigatorEntity") {
      return NavigatorEntity.fromJson(json) as T;
    } else if (T.toString() == "ProductEntity") {
      return ProductEntity.fromJson(json) as T;
    } else if (T.toString() == "BannersEntity") {
      return BannersEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}