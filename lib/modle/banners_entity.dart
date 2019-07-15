import '../entity_factory.dart';

class BannersEntity {
	String imageUrl;
	DateTime startTime;
	int id;
	DateTime endTime;
	int position;
	int sort;
	String title;
	String url;
	int isNative;

	BannersEntity({this.imageUrl, this.startTime, this.id, this.endTime, this.position, this.sort, this.title, this.url, this.isNative});

	BannersEntity.fromJson(Map<String, dynamic> json) {
		imageUrl = json['imageUrl'];
		startTime = json['startTime'];
		id = json['id'];
		endTime = json['endTime'];
		position = json['position'];
		sort = json['sort'];
		title = json['title'];
		url = json['url'];
		isNative = json['isNative'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['imageUrl'] = this.imageUrl;
		data['startTime'] = this.startTime;
		data['id'] = this.id;
		data['endTime'] = this.endTime;
		data['position'] = this.position;
		data['sort'] = this.sort;
		data['title'] = this.title;
		data['url'] = this.url;
		data['isNative'] = this.isNative;
		return data;
	}


}

