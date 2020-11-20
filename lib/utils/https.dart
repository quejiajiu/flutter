import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'dart:collection';
import 'config.dart';

///http请求管理类，可单独抽取出来
class HttpRequest {
  static String _baseUrl = Config.baseUrl;
  static const CONTENT_TYPE_JSON = "application/json;charset=UTF-8";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
  };
  static setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static get(url, {param}) async {
    return await request(
        _baseUrl + url, param, null, new Options(method: "GET"));
  }

  static post(url, param, {Map<String, String> header}) async {
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    return await request(_baseUrl + url, param,
        {"Accept": CONTENT_TYPE_JSON, ...headers}, new Options(method: 'POST'));
  }

  static delete(url, param) async {
    return await request(
        _baseUrl + url, param, null, new Options(method: 'DELETE'));
  }

  static put(url, param) async {
    return await request(_baseUrl + url, param, null,
        new Options(method: "PUT", contentType: ContentType.text));
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static request(url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Response errorResponse;
      errorResponse = new Response(statusCode: 444);
      return errorResponse;
    }
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    //授权码

    headers["Authorization"] = await getAuthorization();

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    ///超时
    option.connectTimeout = 30000;

    Dio dio = new Dio();
    // 强行信任
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    // 添加拦截器
    if (true) {
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        if (option.headers['noToken'] == '' &&
            option.headers['Authorization'] == '') {
          //
          print("\n==========这个接口不需要token======================");
        }
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
      }, onResponse: (Response response) {
        print("\n================== 响应数据 ==========================");
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        if (response.data['code'] == 666) {
          //
          print("\n================== token过期啦 ==========================");
        }
      }, onError: (DioError e) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("stackTrace = ${e.stackTrace}");
        print("\n");
      }));
    }

    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
      return response;
    } on DioError catch (e) {
      // 请求错误处理
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      return errorResponse;
    }
  }

  ///清除授权
  static clearAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  ///获取授权token
  static getAuthorization({token}) async {
    // String token = await SpUtils.get(Config.TOKEN_KEY);
    // if (token == null) {
    //   String basic = await SpUtils.get(Config.USER_BASIC_CODE);
    //   if (basic == null) {
    //     //提示输入账号密码
    //   } else {
    //     //通过 basic 去获取token，获取到设置，返回token
    //     return "Basic $basic";
    //   }
    // } else {
    //   return token;
    // }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }
}
