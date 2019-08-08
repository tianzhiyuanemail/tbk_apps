class UserInfoEntity {
	String tocken;
	String recommendationCode;
	String avatarUrl;
	String phone;
	int level;
	String brithday;
	String name;
	int id;
	String email;
	String parentId;

	UserInfoEntity({this.tocken, this.recommendationCode, this.avatarUrl, this.phone, this.level, this.brithday, this.name, this.id, this.email, this.parentId});

	UserInfoEntity.fromJson(Map<String, dynamic> json) {
		tocken = json['tocken'];
		recommendationCode = json['recommendationCode'];
		avatarUrl = json['avatarUrl'];
		phone = json['phone'];
		level = json['level'];
		brithday = json['brithday'];
		name = json['name'];
		id = json['id'];
		email = json['email'];
		parentId = json['parentId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['tocken'] = this.tocken;
		data['recommendationCode'] = this.recommendationCode;
		data['avatarUrl'] = this.avatarUrl;
		data['phone'] = this.phone;
		data['level'] = this.level;
		data['brithday'] = this.brithday;
		data['name'] = this.name;
		data['id'] = this.id;
		data['email'] = this.email;
		data['parentId'] = this.parentId;
		return data;
	}
}
