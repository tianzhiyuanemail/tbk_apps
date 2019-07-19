const serviceUrl= 'http://localhost:8090/';
//const serviceUrl= 'http://www.shuzibika.com/';
const servicePath={
//  'homePageContext': serviceUrl+'tbk/banners.json', // 商家首页信息
  'banners/queryListForMap': serviceUrl+'tbk/tbk/banners/queryListForMap.json', // 商家首页信息
  'homeNavigator/queryListForMap': serviceUrl+'tbk/tbk/homeNavigator/queryListForMap.json', // 商家首页信息
  'homePageGoods': serviceUrl+'tbk/getTodaySelection.json', // 商家首页信息
  'cateGetList': serviceUrl+'/tbk/product/cate/getList.json', // 商品分类
  'cateListByPid': serviceUrl+'tbk/cateListByPid.json', // 商品一级分类
  'getProductInfo': serviceUrl+'tbk/getProductInfo.json', // 商品信息
  'getProductList': serviceUrl+'tbk/getProductList.json', // 获取商品列表 商品搜索 商品分类
  'getProductDetail': 'http://h5api.m.taobao.com/h5/mtop.taobao.detail.getdesc/6.0/', // 商品信息



};