class CateEntity {
	List<CateEntity> data;
	String cateId;
	int id;
	String cateIcon;
	String cateName;
	String parentId;

	CateEntity({this.data, this.cateId, this.id, this.cateIcon, this.cateName, this.parentId});

	CateEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<CateEntity>();(json['data'] as List).forEach((v) { data.add(new CateEntity.fromJson(v)); });
		}
		cateId = json['cateId'];
		id = json['id'];
		cateIcon = json['cateIcon'];
		cateName = json['cateName'];
		parentId = json['parentId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['cateId'] = this.cateId;
		data['id'] = this.id;
		data['cateIcon'] = this.cateIcon;
		data['cateName'] = this.cateName;
		data['parentId'] = this.parentId;
		return data;
	}
}
