class BrandItemListEntity {
	String fqBrandName;
	List<BrandItemListItem> item;
	String tbBrandName;
	String brandcat;
	String introduce;
	String id;
	String brandLogo;

	BrandItemListEntity({this.fqBrandName, this.item, this.tbBrandName, this.brandcat, this.introduce, this.id, this.brandLogo});

	BrandItemListEntity.fromJson(Map<String, dynamic> json) {
		fqBrandName = json['fq_brand_name'];
		if (json['item'] != null) {
			item = new List<BrandItemListItem>();(json['item'] as List).forEach((v) { item.add(new BrandItemListItem.fromJson(v)); });
		}
		tbBrandName = json['tb_brand_name'];
		brandcat = json['brandcat'];
		introduce = json['introduce'];
		id = json['id'];
		brandLogo = json['brand_logo'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fq_brand_name'] = this.fqBrandName;
		if (this.item != null) {
      data['item'] =  this.item.map((v) => v.toJson()).toList();
    }
		data['tb_brand_name'] = this.tbBrandName;
		data['brandcat'] = this.brandcat;
		data['introduce'] = this.introduce;
		data['id'] = this.id;
		data['brand_logo'] = this.brandLogo;
		return data;
	}
}

class BrandItemListItem {
	String itemendprice;
	String couponurl;
	String shoptype;
	String couponmoney;
	String couponendtime;
	String itemid;
	String itemdesc;
	String sellernick;
	String activityType;
	String itemprice;
	String tkrates;
	String itemtitle;
	String sonCategory;
	String itemsale;
	String itemshorttitle;
	String endTime;
	String itemsale2;
	String brandName;
	String generalIndex;
	String couponexplain;
	String todaysale;
	String startTime;
	String couponstarttime;
	String tkmoney;
	String itempic;
	String shopname;
	String itempicCopy;
	String shopid;
	String tktype;

	BrandItemListItem({this.itemendprice, this.couponurl, this.shoptype, this.couponmoney, this.couponendtime, this.itemid, this.itemdesc, this.sellernick, this.activityType, this.itemprice, this.tkrates, this.itemtitle, this.sonCategory, this.itemsale, this.itemshorttitle, this.endTime, this.itemsale2, this.brandName, this.generalIndex, this.couponexplain, this.todaysale, this.startTime, this.couponstarttime, this.tkmoney, this.itempic, this.shopname, this.itempicCopy, this.shopid, this.tktype});

	BrandItemListItem.fromJson(Map<String, dynamic> json) {
		itemendprice = json['itemendprice'];
		couponurl = json['couponurl'];
		shoptype = json['shoptype'];
		couponmoney = json['couponmoney'];
		couponendtime = json['couponendtime'];
		itemid = json['itemid'];
		itemdesc = json['itemdesc'];
		sellernick = json['sellernick'];
		activityType = json['activity_type'];
		itemprice = json['itemprice'];
		tkrates = json['tkrates'];
		itemtitle = json['itemtitle'];
		sonCategory = json['son_category'];
		itemsale = json['itemsale'];
		itemshorttitle = json['itemshorttitle'];
		endTime = json['end_time'];
		itemsale2 = json['itemsale2'];
		brandName = json['brand_name'];
		generalIndex = json['general_index'];
		couponexplain = json['couponexplain'];
		todaysale = json['todaysale'];
		startTime = json['start_time'];
		couponstarttime = json['couponstarttime'];
		tkmoney = json['tkmoney'];
		itempic = json['itempic'];
		shopname = json['shopname'];
		itempicCopy = json['itempic_copy'];
		shopid = json['shopid'];
		tktype = json['tktype'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['itemendprice'] = this.itemendprice;
		data['couponurl'] = this.couponurl;
		data['shoptype'] = this.shoptype;
		data['couponmoney'] = this.couponmoney;
		data['couponendtime'] = this.couponendtime;
		data['itemid'] = this.itemid;
		data['itemdesc'] = this.itemdesc;
		data['sellernick'] = this.sellernick;
		data['activity_type'] = this.activityType;
		data['itemprice'] = this.itemprice;
		data['tkrates'] = this.tkrates;
		data['itemtitle'] = this.itemtitle;
		data['son_category'] = this.sonCategory;
		data['itemsale'] = this.itemsale;
		data['itemshorttitle'] = this.itemshorttitle;
		data['end_time'] = this.endTime;
		data['itemsale2'] = this.itemsale2;
		data['brand_name'] = this.brandName;
		data['general_index'] = this.generalIndex;
		data['couponexplain'] = this.couponexplain;
		data['todaysale'] = this.todaysale;
		data['start_time'] = this.startTime;
		data['couponstarttime'] = this.couponstarttime;
		data['tkmoney'] = this.tkmoney;
		data['itempic'] = this.itempic;
		data['shopname'] = this.shopname;
		data['itempic_copy'] = this.itempicCopy;
		data['shopid'] = this.shopid;
		data['tktype'] = this.tktype;
		return data;
	}
}
