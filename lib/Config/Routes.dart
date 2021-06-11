import 'package:ce_ccsl_new/Login/loginPage.dart';
import 'package:ce_ccsl_new/page/Home/HomePage.dart';
import 'package:ce_ccsl_new/page/News/detail.dart';
import 'package:ce_ccsl_new/page/News/newsList.dart';
import 'package:ce_ccsl_new/page/SaoMa/saoMas.dart';
import 'package:ce_ccsl_new/page/Tabs.dart';
import 'package:get/get.dart';

final routes = [
  GetPage(name: '/', page: () => Tabs()),
  GetPage(name: '/HomePage', page: () => HomePage()),
  GetPage(name: '/SaoMa', page: () => FullScreenScannerPage()),
  GetPage(name: '/News', page: () => News()),
 GetPage(name: '/News/detail', page: () => Detail()),
  GetPage(name: '/Login', page: () => LoginPage()),
];
