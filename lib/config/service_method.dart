import 'dart:core' as prefix0;
import 'dart:core';

import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';



Future getHomePageContent() async{

  try{
    Response response;
    Dio dio = new Dio();
//    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon':'115.02932','lat':'35.76189','parentId':'0'};
    response = await dio.get(servicePath['homePageContext']+'?parentId='+'0');
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }

}

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

Future getHttpRes (String path,String parms) async{

  print("传入参数"+servicePath[path]+'?'+parms);
  try{
    Dio dio = new Dio();
    Response response = await dio.get(servicePath[path]+'?'+parms );
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }

}