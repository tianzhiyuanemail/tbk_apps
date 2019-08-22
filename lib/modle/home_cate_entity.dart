import 'cate_entity.dart';

class HomeCateEntity {
	String image;
	int urlType;
	List<CateEntity> data;
	String cateId;
	int id;
	int sort;
	String cateIcon;
	String cateName;
	String parentId;
	String url;

	HomeCateEntity({this.image, this.urlType, this.data, this.cateId, this.id, this.sort, this.cateIcon, this.cateName, this.parentId, this.url});

	HomeCateEntity.fromJson(Map<String, dynamic> json) {
		image = json['image'];
		urlType = json['urlType'];
		if (json['data'] != null) {
			data = new List<CateEntity>();(json['data'] as List).forEach((v) { data.add(new CateEntity.fromJson(v)); });
		}
		cateId = json['cateId'];
		id = json['id'];
		sort = json['sort'];
		cateIcon = json['cateIcon'];
		cateName = json['cateName'];
		parentId = json['parentId'];
		url = json['url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['image'] = this.image;
		data['urlType'] = this.urlType;
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['cateId'] = this.cateId;
		data['id'] = this.id;
		data['sort'] = this.sort;
		data['cateIcon'] = this.cateIcon;
		data['cateName'] = this.cateName;
		data['parentId'] = this.parentId;
		data['url'] = this.url;
		return data;
	}
}
