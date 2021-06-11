import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

var cookies;
// or new Dio with a BaseOptions instance.
var options = BaseOptions(
    baseUrl: 'http://tms.cambodianexpress.com',
    connectTimeout: 40000, // 连接超时
    receiveTimeout: 20000, // 接收超时
    headers: {
      'contentType': "application/json",
    });
Dio dio = Dio(options);
var cookieJar = CookieJar();

class Http {
  // or new Dio with a BaseOptions instance.
  // var options = BaseOptions(
  //     baseUrl: 'http://tms.cambodianexpress.com',
  //     connectTimeout: 20000, // 连接超时
  //     receiveTimeout: 10000, // 接收超时
  //     headers: {
  //       'contentType': "application/x-www-form-urlencoded; charset=UTF-8",
  //     });

  // Dio dio = Dio();
  // var cookieJar = CookieJar();

  String csrfToken = '';
  get urlsf => null;

  gets() async {}

  getUrl({url}) async {
    dio.interceptors.add(CookieManager(cookieJar));
    try {
      var response = await dio.get(url);
      return response;
      // if (response.statusCode == 200) {
      //   return response.data;
      // }
    } catch (e) {
      print(e);
    }
    //return url;
  }

  post({url, data}) async {
    try {
      var response = await dio.post(
        url,
        data: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print(response.data);
      print(response.headers);

      print(response.statusCode);
      print(response);
    } catch (e) {
      print('错误');
      print(e);
    }
    await cookieJar.loadForRequest(Uri.parse(options.baseUrl));
  }

  postLogin({url, data}) async {
    //BotToast.showText(text: "xxxx"); //弹出一个文本框;

    BotToast.showLoading(); //弹出一个加载动画

    BaseOptions options = BaseOptions();
    options.baseUrl = 'http://api.ceccsl.com';
    options.contentType = "application/x-www-form-urlencoded; charset=UTF-8";
    //options.method = "POST";
    options.connectTimeout = 60000;
    Dio dio = Dio(options);
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      var response = await dio.post(
        url,
        data: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      BotToast.closeAllLoading();
      if (response.statusCode == 200) {
        print('用户名密码错误');
        BotToast.showSimpleNotification(title: "用户名密码错误".tr); //弹出简单通知Toast
      } else if (response.statusCode == 302) {
        cookies = await cookieJar.loadForRequest(Uri.parse(options.baseUrl));
        print(cookies);
        print('登录成功1');
        //print(await cookieJar.loadForRequest(Uri.parse(options.baseUrl)));
        return true;
      } else {
        print('请稍后尝试');
        BotToast.showSimpleNotification(title: "请稍后尝试".tr); //弹出简单通知Toast
      }
    } catch (e) {
      //print('错误2');
      errorType(e);
    }

    //await cookieJar.loadForRequest(Uri.parse(options.baseUrl));
  }

  static void errorType(e) {
    
    switch (e.type) {
      case DioErrorType.other:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(
            title: '请检查网络连接是否正常', duration: Duration(seconds: 5));
        break;

      case DioErrorType.connectTimeout:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '请求超时请稍后尝试');
        break;
      case DioErrorType.sendTimeout:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '发送请求超时请稍后尝试');
        break;
      case DioErrorType.receiveTimeout:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '接收请求超时请稍后尝试');
        break;
      case DioErrorType.response:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '服务器响应状态错误');
        break;
      case DioErrorType.cancel:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '请求已取消');
        break;
      default:
        BotToast.closeAllLoading();
        BotToast.showSimpleNotification(title: '其他错误');
        break;
    }
  }

  postQ({url, data}) async {
    try {
      print('2222');

      //dio.options.headers['X-CSRF-TOKEN'] = csrf_token;
      dio.options.headers['X-CSRF-TOKEN'] =
          'ff9dace4-1f8c-40cf-96c4-59aecc15d1b7';
      //dio.options.headers['cookie'] = cookies[0];
      dio.options.headers['Host'] = 'tms.cambodianexpress.com';
      dio.options.headers['Cookie'] =
          '_ga=GA1.2.743124396.1602756677; loginKey=d2b8b3c1-53d2-41e3-966b-51a3149a2723; SESSIONID_HAP=faa0c878-e4f9-43e1-835f-0b34b1727151';
      print(dio.options.headers);
      var response = await dio.post(
          'http://tms.cambodianexpress.com/tms/courier/provison/query',
          data: data);

      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
