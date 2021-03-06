class ProductListEntity {
	String commissionRate;
	String reservePrice;
	String whiteImage;
	String includeDxjh;
	int numIid;
	String shortTitle;
	String couponId;
	String title;
	String categoryName;
	String couponShareUrl;
	String zkFinalPrice;
	String nick;
	List<String> smallImages;
	String couponAmount;
	String xid;
	int sellerId;
	String tkTotalSales;
	String couponStartTime;
	int shopDsr;
	String itemDescription;
	String includeMkt;
	int levelOneCategoryId;
	String tkTotalCommi;
	String couponStartFee;
	int couponRemainCount;
	String levelOneCategoryName;
	String couponInfo;
	String afterCouponPrice;
	String pictUrl;
	String tmallPlayActivityInfo;
	String realPostFee;
	String commissionType;
	String url;
	String couponEndTime;
	int couponTotalCount;
	int volume;
	int itemId;
	String infoDxjh;
	String provcity;
	String shopTitle;
	String couponPrice;
	int userType;
	String itemUrl;
	int categoryId;

	ProductListEntity({this.commissionRate, this.reservePrice, this.whiteImage, this.includeDxjh, this.numIid, this.shortTitle, this.couponId, this.title, this.categoryName, this.couponShareUrl, this.zkFinalPrice, this.nick, this.smallImages, this.couponAmount, this.xid, this.sellerId, this.tkTotalSales, this.couponStartTime, this.shopDsr, this.itemDescription, this.includeMkt, this.levelOneCategoryId, this.tkTotalCommi, this.couponStartFee, this.couponRemainCount, this.levelOneCategoryName, this.couponInfo, this.afterCouponPrice, this.pictUrl, this.tmallPlayActivityInfo, this.realPostFee, this.commissionType, this.url, this.couponEndTime, this.couponTotalCount, this.volume, this.itemId, this.infoDxjh, this.provcity, this.shopTitle, this.couponPrice, this.userType, this.itemUrl, this.categoryId});

	ProductListEntity.fromJson(Map<String, dynamic> json) {
		commissionRate = json['commissionRate'];
		reservePrice = json['reservePrice'];
		whiteImage = json['whiteImage'];
		includeDxjh = json['includeDxjh'];
		numIid = json['numIid'];
		shortTitle = json['shortTitle'];
		couponId = json['couponId'];
		title = json['title'];
		categoryName = json['categoryName'];
		couponShareUrl = json['couponShareUrl'];
		zkFinalPrice = json['zkFinalPrice'];
		nick = json['nick'];
//		smallImages = json['smallImages']?.cast<String>();
		couponAmount = json['couponAmount'];
		xid = json['xid'];
		sellerId = json['sellerId'];
		tkTotalSales = json['tkTotalSales'];
		couponStartTime = json['couponStartTime'];
		shopDsr = json['shopDsr'];
		itemDescription = json['itemDescription'];
		includeMkt = json['includeMkt'];
		levelOneCategoryId = json['levelOneCategoryId'];
		tkTotalCommi = json['tkTotalCommi'];
		couponStartFee = json['couponStartFee'];
		couponRemainCount = json['couponRemainCount'];
		levelOneCategoryName = json['levelOneCategoryName'];
		couponInfo = json['couponInfo'];
		afterCouponPrice = json['afterCouponPrice'];
		pictUrl = json['pictUrl'];
		tmallPlayActivityInfo = json['tmallPlayActivityInfo'];
		realPostFee = json['realPostFee'];
		commissionType = json['commissionType'];
		url = json['url'];
		couponEndTime = json['couponEndTime'];
		couponTotalCount = json['couponTotalCount'];
		volume = json['volume'];
		itemId = json['itemId'];
		infoDxjh = json['infoDxjh'];
		provcity = json['provcity'];
		shopTitle = json['shopTitle'];
		couponPrice = json['couponPrice'];
		userType = json['userType'];
		itemUrl = json['itemUrl'];
		categoryId = json['categoryId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['commissionRate'] = this.commissionRate;
		data['reservePrice'] = this.reservePrice;
		data['whiteImage'] = this.whiteImage;
		data['includeDxjh'] = this.includeDxjh;
		data['numIid'] = this.numIid;
		data['shortTitle'] = this.shortTitle;
		data['couponId'] = this.couponId;
		data['title'] = this.title;
		data['categoryName'] = this.categoryName;
		data['couponShareUrl'] = this.couponShareUrl;
		data['zkFinalPrice'] = this.zkFinalPrice;
		data['nick'] = this.nick;
		data['smallImages'] = this.smallImages;
		data['couponAmount'] = this.couponAmount;
		data['xid'] = this.xid;
		data['sellerId'] = this.sellerId;
		data['tkTotalSales'] = this.tkTotalSales;
		data['couponStartTime'] = this.couponStartTime;
		data['shopDsr'] = this.shopDsr;
		data['itemDescription'] = this.itemDescription;
		data['includeMkt'] = this.includeMkt;
		data['levelOneCategoryId'] = this.levelOneCategoryId;
		data['tkTotalCommi'] = this.tkTotalCommi;
		data['couponStartFee'] = this.couponStartFee;
		data['couponRemainCount'] = this.couponRemainCount;
		data['levelOneCategoryName'] = this.levelOneCategoryName;
		data['couponInfo'] = this.couponInfo;
		data['afterCouponPrice'] = this.afterCouponPrice;
		data['pictUrl'] = this.pictUrl;
		data['tmallPlayActivityInfo'] = this.tmallPlayActivityInfo;
		data['realPostFee'] = this.realPostFee;
		data['commissionType'] = this.commissionType;
		data['url'] = this.url;
		data['couponEndTime'] = this.couponEndTime;
		data['couponTotalCount'] = this.couponTotalCount;
		data['volume'] = this.volume;
		data['itemId'] = this.itemId;
		data['infoDxjh'] = this.infoDxjh;
		data['provcity'] = this.provcity;
		data['shopTitle'] = this.shopTitle;
		data['couponPrice'] = this.couponPrice;
		data['userType'] = this.userType;
		data['itemUrl'] = this.itemUrl;
		data['categoryId'] = this.categoryId;
		return data;
	}
}
