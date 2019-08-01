import 'material_entity.dart';

class HomeNavigatorEntity {
	List<Materialentity> materialEntityList;
	String imageUrl;
	int id;
	int sort;
	String title;
	String url;
	int isNative;

	HomeNavigatorEntity({this.materialEntityList, this.imageUrl, this.id, this.sort, this.title, this.url, this.isNative});

	HomeNavigatorEntity.fromJson(Map<String, dynamic> json) {
		if (json['materialEntityList'] != null) {
			materialEntityList = new List<Materialentity>();(json['materialEntityList'] as List).forEach((v) { materialEntityList.add(new Materialentity.fromJson(v)); });
		}
		imageUrl = json['imageUrl'];
		id = json['id'];
		sort = json['sort'];
		title = json['title'];
		url = json['url'];
		isNative = json['isNative'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.materialEntityList != null) {
      data['materialEntityList'] =  this.materialEntityList.map((v) => v.toJson()).toList();
    }
		data['imageUrl'] = this.imageUrl;
		data['id'] = this.id;
		data['sort'] = this.sort;
		data['title'] = this.title;
		data['url'] = this.url;
		data['isNative'] = this.isNative;
		return data;
	}
}
