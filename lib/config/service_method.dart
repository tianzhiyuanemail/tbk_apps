import 'dart:core' as prefix0;
import 'dart:core';

import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';
import 'loading.dart';


/// todo 即将清除 该方法
Future getHomePageGoods(int page) async{

  try{
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['homePageGoods']+'?pageNo='+page.toString());
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }

}
Future getCatePage ( ) async{

  try{
    Response response;
    Dio dio = new Dio();
    response = await dio.get(servicePath['cateListAll']+'?parentId=0' );
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }

}




