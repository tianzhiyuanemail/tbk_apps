class ProductRecommendEntity {
	String productId;
	String imageUrl;
	double afterCouponPrice;
	double couponPrice;
	int id;
	int sort;
	String hotType;
	double zkFinalPrice;

	ProductRecommendEntity({this.productId, this.imageUrl, this.afterCouponPrice, this.couponPrice, this.id, this.sort, this.hotType, this.zkFinalPrice});

	ProductRecommendEntity.fromJson(Map<String, dynamic> json) {
		productId = json['productId'];
		imageUrl = json['imageUrl'];
		afterCouponPrice = json['afterCouponPrice'];
		couponPrice = json['couponPrice'];
		id = json['id'];
		sort = json['sort'];
		hotType = json['hotType'];
		zkFinalPrice = json['zkFinalPrice'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['productId'] = this.productId;
		data['imageUrl'] = this.imageUrl;
		data['afterCouponPrice'] = this.afterCouponPrice;
		data['couponPrice'] = this.couponPrice;
		data['id'] = this.id;
		data['sort'] = this.sort;
		data['hotType'] = this.hotType;
		data['zkFinalPrice'] = this.zkFinalPrice;
		return data;
	}
}
