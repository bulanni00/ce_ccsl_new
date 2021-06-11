import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

class HttpLogin {
  postLogin({required String url, data}) async {
    //BotToast.showText(text: "xxxx"); //弹出一个文本框;

    BotToast.showLoading(); //弹出一个加载动画

    BaseOptions options = BaseOptions();
    options.baseUrl = 'http://tms.cambodianexpress.com';
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
        print('登录成功');
        return true;
      } else {
        print('请稍后尝试');
        BotToast.showSimpleNotification(title: "请稍后尝试".tr); //弹出简单通知Toast
      }
    } on DioError catch (e) {
      print('错误2');
      //print(e);
      BotToast.closeAllLoading();
      BotToast.showSimpleNotification(title: e.message);
    }
    print(await cookieJar.loadForRequest(Uri.parse(options.baseUrl)));
    //await cookieJar.loadForRequest(Uri.parse(options.baseUrl));
  }
}
