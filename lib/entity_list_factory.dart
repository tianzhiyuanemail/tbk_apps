

import 'entity_factory.dart';

class EntityListFactory {
  static List<T> generateList<T>(List<dynamic> list) {
    return list.map((obj) {
      return EntityFactory.generateOBJ<T>(obj);
    }).toList();
  }
}