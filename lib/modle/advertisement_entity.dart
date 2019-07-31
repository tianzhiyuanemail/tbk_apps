class AdvertisementEntity {
	String imageUrl;
	int id;
	int position;
	String url;
	int isNative;

	AdvertisementEntity({this.imageUrl, this.id, this.position, this.url, this.isNative});

	AdvertisementEntity.fromJson(Map<String, dynamic> json) {
		imageUrl = json['imageUrl'];
		id = json['id'];
		position = json['position'];
		url = json['url'];
		isNative = json['isNative'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['imageUrl'] = this.imageUrl;
		data['id'] = this.id;
		data['position'] = this.position;
		data['url'] = this.url;
		data['isNative'] = this.isNative;
		return data;
	}
}
