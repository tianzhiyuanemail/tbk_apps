/*
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */

import 'package:tbk_app/util/conversion_util.dart';

class ProductModel {
  String commissionRate = "";
  String commissionType = "";
  String couponEndTime = "";
  String couponId = "";
  String couponInfo = "";
  String couponRemainCount = "";
  String couponShareUrl = "";
  String couponStartTime = "";
  String couponTotalCount = "";
  bool includeDxjh = false;
  bool includeMkt = false;
  String infoDxjh = "";
  String itemUrl = "";
  String numIid = "";
  String pictUrl = "";
  String provcity = "";
  String reservePrice = "";
  String sellerId = "";
  String shopDsr = "";
  String shopTitle = "";
  List<String> smallImages = [];
  String title = "";
  String tkTotalCommi = "";
  String tkTotalSales = "";
  String url = "";
  String userType = "";
  String volume = "";
  String zkFinalPrice = "";
  String afterCouponPrice = "";
  String couponPrice = "";
  String couponModel = "";
  String itemDescription = "";

  ProductModel(
      {this.commissionRate,
      this.commissionType,
      this.couponEndTime,
      this.couponId,
      this.couponInfo,
      this.couponRemainCount,
      this.couponShareUrl,
      this.couponStartTime,
      this.couponTotalCount,
      this.includeDxjh,
      this.includeMkt,
      this.infoDxjh,
      this.itemUrl,
      this.numIid,
      this.pictUrl,
      this.provcity,
      this.reservePrice,
      this.sellerId,
      this.shopDsr,
      this.shopTitle,
      this.smallImages,
      this.title,
      this.tkTotalCommi,
      this.tkTotalSales,
      this.url,
      this.userType,
      this.volume,
      this.zkFinalPrice,
      this.afterCouponPrice,
      this.couponPrice,
      this.couponModel,
      this.itemDescription});

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      commissionRate: json['commissionRate'].toString(),
      commissionType: json['commissionType'].toString(),
      couponEndTime: json['couponEndTime'].toString(),
      couponId: json['couponId'].toString(),
      couponInfo: json['couponInfo'].toString(),
      couponRemainCount: json['couponRemainCount'].toString(),
      couponShareUrl: json['couponShareUrl'].toString(),
      couponStartTime: json['couponStartTime'].toString(),
      couponTotalCount: json['couponTotalCount'].toString(),
      includeDxjh: json['includeDxjh'] == 'true'?true:false,
      includeMkt: json['includeMkt']  == 'true'?true:false,
      infoDxjh: json['infoDxjh'].toString(),
      itemUrl: json['itemUrl'].toString(),
      numIid: json['numIid'].toString(),
      pictUrl: json['pictUrl'].toString(),
      provcity: json['provcity'].toString(),
      reservePrice: json['reservePrice'].toString(),
      sellerId: json['sellerId'].toString(),
      shopDsr: json['shopDsr'].toString(),
      shopTitle: json['shopTitle'].toString(),
      smallImages: listOfDToS(json['smallImages'] as List),
      title: json['title'].toString(),
      tkTotalCommi: json['tkTotalCommi'].toString(),
      tkTotalSales: json['tkTotalSales'].toString(),
      url: json['url'].toString(),
      userType: json['userType'].toString(),
      volume: json['volume'].toString(),
      zkFinalPrice: json['zkFinalPrice'].toString(),
      afterCouponPrice: json['afterCouponPrice'].toString(),
      couponPrice: json['couponPrice'].toString(),
      couponModel: json['couponModel'].toString(),
      itemDescription: json['itemDescription'].toString(),
    );
  }
}

