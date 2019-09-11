class BrandTodayItemListEntity {
	TodayBrandItemListData data;
	List<Null> items;

	BrandTodayItemListEntity({this.data, this.items});

	BrandTodayItemListEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new TodayBrandItemListData.fromJson(json['data']) : null;
		if (json['items'] != null) {
			items = new List<Null>();
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		if (this.items != null) {
      data['items'] =  [];
    }
		return data;
	}
}

class TodayBrandItemListData {
	String background;
	String actitvityEndtime;
	int num;
	String name;
	List<String> multiple;
	String id;
	String brandLogo;
	String title;

	TodayBrandItemListData({this.background, this.actitvityEndtime, this.num, this.name, this.multiple, this.id, this.brandLogo, this.title});

	TodayBrandItemListData.fromJson(Map<String, dynamic> json) {
		background = json['background'];
		actitvityEndtime = json['actitvity_endtime'];
		num = json['num'];
		name = json['name'];
		multiple = json['multiple']?.cast<String>();
		id = json['id'];
		brandLogo = json['brand_logo'];
		title = json['title'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['background'] = this.background;
		data['actitvity_endtime'] = this.actitvityEndtime;
		data['num'] = this.num;
		data['name'] = this.name;
		data['multiple'] = this.multiple;
		data['id'] = this.id;
		data['brand_logo'] = this.brandLogo;
		data['title'] = this.title;
		return data;
	}
}
