import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:tbk_app/config/service_url.dart';
import 'package:tbk_app/util/sp_util.dart';

class HttpUtil {
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = new CancelToken();

  /*
   * config it and create
   */
  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: "http://www.google.com",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0",
        "Authorization": SpUtil.getString("tocken"),
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    dio = new Dio(options);

    //Cookie管理
    dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");

      // Do something before request is sent
//      Loading.before(options.uri, '正在加速中...');
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前");

//      Future.delayed(Duration(seconds: 3), () {
//        Loading.complete(response.request.uri );
//        return response;
//      });
//        Loading.complete(response.request.uri );
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("错误之前");
      // Do something with response error
      return e; //continue
    }));
  }

  /*
   * get请求
   */
  Future get(path, {parms, data, options, cancelToken}) async {
//    dio.options.headers.putIfAbsent("", SpUtil.getString("tocken"));
    print("传入参数${servicePath[path]}?${parms}");

    Response response;
    try {
      response = await dio.get("${servicePath[path]}?${parms}",
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');

      //      response.data; 响应体
      //      response.headers; 响应头
      //      response.request; 请求体
      //      response.statusCode; 状态码

    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * get请求
   */
  Future getAllPath(path, { data, options, cancelToken}) async {
    print("传入参数${data}");

    Response response;
    try {
      response = await dio.get(path,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');

      //      response.data; 响应体
      //      response.headers; 响应头
      //      response.request; 请求体
      //      response.statusCode; 状态码

    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * post请求
   */
  Future post(path, parms, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await dio.post(path + "?" + parms,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response.data;
  }

  // 上传图片
  Future uploadImg(imgfile) async {
    String path = imgfile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(path), name),
      "contents": "tbk/user/",
    });
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath['uploadFile'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常');
    }
  }

  /*
   * 下载文件
   */
  Future downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
