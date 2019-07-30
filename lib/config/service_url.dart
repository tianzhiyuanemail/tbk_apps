const serviceUrl= 'http://localhost:8090/';
//const serviceUrl= 'http://www.shuzibika.com/';
const servicePath={

  /// index
  'homePageGoods': serviceUrl+'tbk/getTodaySelection.json', //  好券清单
  'banners/queryListForMap': serviceUrl+'tbk/tbk/banners/queryListForMap.json', // 首页banner
  'productRecommends': serviceUrl+'tbk/product/productRecommend/getList.json', // 商品推荐
  'homeNavigator/queryListForMap': serviceUrl+'tbk/tbk/homeNavigator/queryListForMap.json', // 首页homeNavigator


  /// cate
  'cateGetList': serviceUrl+'/tbk/product/cate/getList.json', // 商品分类
  'cateListByPid': serviceUrl+'tbk/cateListByPid.json', // 商品一级分类

  /// product detail
  'getProductInfo': serviceUrl+'tbk/getProductInfo.json', // 商品信息
  'getProductDetail': 'http://h5api.m.taobao.com/h5/mtop.taobao.detail.getdesc/6.0/', // 商品信息

  /// product list
  'getProductList': serviceUrl+'tbk/getProductList.json', // 获取商品列表 商品搜索 商品分类


  /// my


};