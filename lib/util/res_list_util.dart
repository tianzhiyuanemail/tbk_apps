class ResListEntity<T> {
  List<T> list;
  int page;
  bool hasMore;

  ResListEntity({this.list, this.page, this.hasMore});


}

class ResListUtil<T> {
  static ResListEntity buildResList<T>(ResListEntity listEntity ,  List<T> listRes) {
    if (listRes == null || listRes.length == 0) {
      listEntity.hasMore = true;
    } else {
      if (listEntity.page == 0) {
        listEntity.list = listRes;
      } else {
        listEntity.list.addAll(listRes);
      }
      listEntity.page++;
    }

    return listEntity;
  }
}
