class NavigatorEntity {
	String updatedTime;
	String updatedBy;
	String createdBy;
	String imageUrl;
	String createdTime;
	int id;
	int sort;
	String title;
	String url;
	int isNative;

	NavigatorEntity({this.updatedTime, this.updatedBy, this.createdBy, this.imageUrl, this.createdTime, this.id, this.sort, this.title, this.url, this.isNative});

	NavigatorEntity.fromJson(Map<String, dynamic> json) {
		updatedTime = json['updatedTime'];
		updatedBy = json['updatedBy'];
		createdBy = json['createdBy'];
		imageUrl = json['imageUrl'];
		createdTime = json['createdTime'];
		id = json['id'];
		sort = json['sort'];
		title = json['title'];
		url = json['url'];
		isNative = json['isNative'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['updatedTime'] = this.updatedTime;
		data['updatedBy'] = this.updatedBy;
		data['createdBy'] = this.createdBy;
		data['imageUrl'] = this.imageUrl;
		data['createdTime'] = this.createdTime;
		data['id'] = this.id;
		data['sort'] = this.sort;
		data['title'] = this.title;
		data['url'] = this.url;
		data['isNative'] = this.isNative;
		return data;
	}
}
