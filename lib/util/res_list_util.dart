class ResListEntity<T> {
  List<T> list;
  int page;
  bool noMore;
}

class ResListUtil<T> {
  static ResListEntity buildResList<T>(
      List<T> listBase, List<T> listRes, int page, bool noMore) {
    ResListEntity<T> resListEntity = new ResListEntity();
    if (listRes == null || listRes.length == 0) {
      resListEntity.noMore = true;
    } else {
      if (page == 0) {
        listBase = listRes;
      } else {
        listBase.addAll(listRes);
      }
      page++;
    }

    resListEntity.list = listBase;
    resListEntity.page = page;
    resListEntity.noMore = noMore;

    return resListEntity;
  }
}
