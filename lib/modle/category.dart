class CategoryBigModel {

   String cateId;
  String itemCount;
  String parentId;
  List<CategoryBigModel> data;
  String tbkImg;
  String tbkName;

  //构造函数
  CategoryBigModel({
    this.cateId,
    this.itemCount,
    this.parentId,
    this.data,
    this.tbkImg,
    this.tbkName,
   });

  //工厂模式-用这种模式可以省略New关键字
  factory CategoryBigModel.fromJson(dynamic json){
    return CategoryBigModel(
        cateId:json['cateId'].toString(),
        itemCount:json['itemCount'].toString(),
        parentId:json['parentId'].toString(),
        data:json['data'] == null ? null:CategoryBigListModel.formJson(json['data'] as List).data,
        tbkName:json['tbkName'].toString(),
        tbkImg:json['tbkImg'].toString(),
    );
  }

}



class CategoryBigListModel {

  List<CategoryBigModel> data;
  CategoryBigListModel(this.data);
  factory CategoryBigListModel.formJson(List json){
    return CategoryBigListModel(
        json.map((i){
         return CategoryBigModel.fromJson((i));
        }).toList()
    );
  }

}
