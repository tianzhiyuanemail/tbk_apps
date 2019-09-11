class BrandSubjectItemListEntity {
	String brandImage;
	String brandName;
	String brandLogo;
	List<BrandSubjectItemItem> items;
	String brandId;

	BrandSubjectItemListEntity({this.brandImage, this.brandName, this.brandLogo, this.items, this.brandId});

	BrandSubjectItemListEntity.fromJson(Map<String, dynamic> json) {
		brandImage = json['brand_image'];
		brandName = json['brand_name'];
		brandLogo = json['brand_logo'];
		if (json['items'] != null) {
			items = new List<BrandSubjectItemItem>();(json['items'] as List).forEach((v) { items.add(new BrandSubjectItemItem.fromJson(v)); });
		}
		brandId = json['brand_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['brand_image'] = this.brandImage;
		data['brand_name'] = this.brandName;
		data['brand_logo'] = this.brandLogo;
		if (this.items != null) {
      data['items'] =  this.items.map((v) => v.toJson()).toList();
    }
		data['brand_id'] = this.brandId;
		return data;
	}
}

class BrandSubjectItemItem {
	String gradeAvg;
	String itemendprice;
	String couponurl;
	String shoptype;
	String discount;
	String reportStatus;
	String couponmoney;
	String couponendtime;
	String userid;
	String itemid;
	String couponsurplus;
	String itemdesc;
	String sellerName;
	String rateTotal;
	String activityType;
	String itemprice;
	String id;
	String stock;
	String sellerId;
	String tkrates;
	String couponnum;
	String activityPlan;
	String itemtitle;
	String itemsale;
	String isForeshow;
	String itemshorttitle;
	String itemsale2;
	int videoid;
	String brandName;
	String generalIndex;
	String todaysale;
	String activityid;
	String couponstarttime;
	String tkmoney;
	String couponreceive;
	String itempic;
	String shopname;
	String itempicCopy;
	String shopid;
	String downType;

	BrandSubjectItemItem({this.gradeAvg, this.itemendprice, this.couponurl, this.shoptype, this.discount, this.reportStatus, this.couponmoney, this.couponendtime, this.userid, this.itemid, this.couponsurplus, this.itemdesc, this.sellerName, this.rateTotal, this.activityType, this.itemprice, this.id, this.stock, this.sellerId, this.tkrates, this.couponnum, this.activityPlan, this.itemtitle, this.itemsale, this.isForeshow, this.itemshorttitle, this.itemsale2, this.videoid, this.brandName, this.generalIndex, this.todaysale, this.activityid, this.couponstarttime, this.tkmoney, this.couponreceive, this.itempic, this.shopname, this.itempicCopy, this.shopid, this.downType});

	BrandSubjectItemItem.fromJson(Map<String, dynamic> json) {
		gradeAvg = json['grade_avg'];
		itemendprice = json['itemendprice'];
		couponurl = json['couponurl'];
		shoptype = json['shoptype'];
		discount = json['discount'];
		reportStatus = json['report_status'];
		couponmoney = json['couponmoney'];
		couponendtime = json['couponendtime'];
		userid = json['userid'];
		itemid = json['itemid'];
		couponsurplus = json['couponsurplus'];
		itemdesc = json['itemdesc'];
		sellerName = json['seller_name'];
		rateTotal = json['rate_total'];
		activityType = json['activity_type'];
		itemprice = json['itemprice'];
		id = json['id'];
		stock = json['stock'];
		sellerId = json['seller_id'];
		tkrates = json['tkrates'];
		couponnum = json['couponnum'];
		activityPlan = json['activity_plan'];
		itemtitle = json['itemtitle'];
		itemsale = json['itemsale'];
		isForeshow = json['is_foreshow'];
		itemshorttitle = json['itemshorttitle'];
		itemsale2 = json['itemsale2'];
		videoid = json['videoid'];
		brandName = json['brand_name'];
		generalIndex = json['general_index'];
		todaysale = json['todaysale'];
		activityid = json['activityid'];
		couponstarttime = json['couponstarttime'];
		tkmoney = json['tkmoney'];
		couponreceive = json['couponreceive'];
		itempic = json['itempic'];
		shopname = json['shopname'];
		itempicCopy = json['itempic_copy'];
		shopid = json['shopid'];
		downType = json['down_type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['grade_avg'] = this.gradeAvg;
		data['itemendprice'] = this.itemendprice;
		data['couponurl'] = this.couponurl;
		data['shoptype'] = this.shoptype;
		data['discount'] = this.discount;
		data['report_status'] = this.reportStatus;
		data['couponmoney'] = this.couponmoney;
		data['couponendtime'] = this.couponendtime;
		data['userid'] = this.userid;
		data['itemid'] = this.itemid;
		data['couponsurplus'] = this.couponsurplus;
		data['itemdesc'] = this.itemdesc;
		data['seller_name'] = this.sellerName;
		data['rate_total'] = this.rateTotal;
		data['activity_type'] = this.activityType;
		data['itemprice'] = this.itemprice;
		data['id'] = this.id;
		data['stock'] = this.stock;
		data['seller_id'] = this.sellerId;
		data['tkrates'] = this.tkrates;
		data['couponnum'] = this.couponnum;
		data['activity_plan'] = this.activityPlan;
		data['itemtitle'] = this.itemtitle;
		data['itemsale'] = this.itemsale;
		data['is_foreshow'] = this.isForeshow;
		data['itemshorttitle'] = this.itemshorttitle;
		data['itemsale2'] = this.itemsale2;
		data['videoid'] = this.videoid;
		data['brand_name'] = this.brandName;
		data['general_index'] = this.generalIndex;
		data['todaysale'] = this.todaysale;
		data['activityid'] = this.activityid;
		data['couponstarttime'] = this.couponstarttime;
		data['tkmoney'] = this.tkmoney;
		data['couponreceive'] = this.couponreceive;
		data['itempic'] = this.itempic;
		data['shopname'] = this.shopname;
		data['itempic_copy'] = this.itempicCopy;
		data['shopid'] = this.shopid;
		data['down_type'] = this.downType;
		return data;
	}
}
