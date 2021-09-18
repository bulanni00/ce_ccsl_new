import 'package:ce_ccsl_new/page/Home/tiaoma.dart';
import 'package:ce_ccsl_new/page/SaoMa/NewSaoMa.dart';
import 'package:ce_ccsl_new/page/SaoMa/saoMas.dart';
import 'package:ce_ccsl_new/utils2/HttpData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart' hide Response;
import 'package:photo_view/photo_view.dart';

class HomePage extends StatefulWidget {
  final arguments;
  HomePage({Key? key, this.arguments}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//
class _HomePageState extends State<HomePage> {
  List listData = [];

  @override
  void initState() {
    if (Get.arguments != null) {
      __get(Get.arguments['code']);
    }
    _getCheData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 解决键盘 https://api.flutter.dev/flutter/material/Scaffold/resizeToAvoidBottomInset.html
      //resizeToAvoidBottomPadding: false,
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('CE.CCSL'),
        centerTitle: true,
        actions: [
          TextButton(
            //icon: Icon(Icons.login_outlined),

            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              //String name = prefs.setString('Name', null);
              prefs.remove('Name');
              prefs.remove('login');
              Get.offNamed('/Login');
              print('退出登录');
            },
            child: Text(
              'sign out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: _body(),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Get.to(TiaoMa());
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  _getCheData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('Name');
    print('sm:::');
    print(name);
    if (name == null) {
      Get.offNamed('/Login');
    }

    await prefs.setInt('N', 1);
  }

  _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getSearchBarUI(),
        _huiyuan(),
      ],
    );
  }

  _huiyuan() {
    if (this.listData == null) {
      return Expanded(
        child: Center(
          child: Text(''),
        ),
      );
    }
    //print(this.listData);

    return Expanded(
      child: ListView(
        //physics: BouncingScrollPhysics(),
        children: this.listData.map<Widget>((v) {
          return Container(
            child: Container(
              //height: 400,
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  elevation: 2.0, //阴影
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  //margin: EdgeInsets.symmetric(vertical: 15.0),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('名称:'.tr),
                            Text('${v['Contact']}'),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('电话:'.tr),
                            InkWell(
                              onTap: () {
                                _showDialog(
                                  context,
                                  title: 'prompt',
                                  centonts: 'dial number ${v['Phone']}',
                                  s1: v['Phone'],
                                );
                                //print(ss);
                              },
                              child: Row(
                                children: [
                                  Text('${v['Phone']}'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.phone_in_talk,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('地址:'.tr),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (v['latitude'] == 0.0) {
                                    BotToast.showText(text: '客户无定位信息'.tr);
                                    return;
                                  }
                                  openMapsSheet(
                                    context,
                                    v['latitude'],
                                    v['longitude'],
                                  );
                                  //openMapsSheet(context, 11.5562167, 104.9097976);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${v['Province'] != null ? v['Province'] : ''} ${v['City'] != null ? v['City'] : ''} ${v['Add'] != null ? v['Add'] : ''}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    v['latitude'] == 0.0
                                        ? Text('')
                                        : Icon(
                                            Icons.room_outlined,
                                            color: Colors.blue,
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('照片:'.tr),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    openDialog(context,
                                        '${v['Img1'] != '' ? v['Img1'] : 'https://ce-client-app.oss-ap-southeast-1.aliyuncs.com/images/null.png'}');
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      '${v['Img1'] != '' ? v['Img1'] : 'https://ce-client-app.oss-ap-southeast-1.aliyuncs.com/images/null.png'}',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                InkWell(
                                  onTap: () {
                                    openDialog(context,
                                        '${v['Img2'] != '' ? v['Img2'] : 'https://ce-client-app.oss-ap-southeast-1.aliyuncs.com/images/null.png'}');
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      '${v['Img2'] != '' ? v['Img2'] : 'https://ce-client-app.oss-ap-southeast-1.aliyuncs.com/images/null.png'}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //放大图片
  openDialog(BuildContext context, String img) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: Dialog(
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(img),
              heroAttributes: const PhotoViewHeroAttributes(tag: ''),
            ),
          ),
        );
      },
    );
  }

  //打开地图
  openMapsSheet(context, lat, lon) async {
    try {
      final coords = Coords(lat, lon);
      final title = 'Ocean Beach';
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  __get(String code) async {
    BotToast.showLoading();
    // 012355426
    if (code.length == 5) {
      code = 'CE' + code;
    }
    if (code.length == 11) {
      code = 'C' + code;
    }
    //String url = '/api/address/getaddress?num=$code';

    Response response;
    var dio = Dio();
    BotToast.showText(text: code);
    response =
        await dio.get('http://api.ceccsl.com/api/address/getaddress?num=$code');
    if (response.statusCode == 200) {
      BotToast.closeAllLoading();
      if (response.data['status'] == 'OK') {
        setState(() {
          listData = response.data['address']; // 地址信息给listData
        });
      } else {
        BotToast.closeAllLoading();
        BotToast.showText(text: '请勿扫描二维码，应扫描一维码'.tr);
      }
    } else {
      BotToast.closeAllLoading();
      BotToast.showText(text: '请稍后尝试'.tr);
    }

    //showAchievementView(context);
    // print(url);
    // GetHttpUrl(url: url, status: 7777).then((value) {
    //   print(value);
    //   if (value == null) {
    //     return;
    //   }
    //   if (value['status'] == 'Error') {
    //     BotToast.showText(text: '未查询到地址信息'.tr);
    //     return;
    //   }

    //   setState(() {
    //     listData = value['address']; // 轨迹信息给listData
    //   });
    // });
  }

  var _code = '运单编号/会员编号'.tr;
//搜索框
  //定义一个controller
  TextEditingController _unameController = TextEditingController();
  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Material(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF90CAF9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    onTap: () async {
                      //关闭键盘
                      FocusScope.of(context).requestFocus(FocusNode());
                      //Get.to(CustomSizeScannerPage());
                      this.listData = [];
                      var data = await Get.to(QRViewExample());
                      print('返回来了什么:$data');
                      if (data != null) {
                        if (data['success'] == 'ok') {
                          __get(data['code']);
                        }
                      }

                      /// 延时2s执行返回
                      // Future.delayed(Duration(seconds: 0.5), () {
                      //   Get.toNamed('/saoma');
                      // });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 6, bottom: 6),
                  child: Container(
                    //height: 45,
                    //width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 5, top: 0, bottom: 1),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        controller: _unameController,
                        onChanged: (String txt) {},
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(top: 14),
                          //isDense: true,
                          border: InputBorder.none,
                          hintText: _code, //默认值
                          // prefix: Expanded(
                          //   child: Text('CE'),
                          // ),
                          prefixText: 'CE ',
                          //labelText: 'CE',
                          // prefixIcon: Center(

                          //   child: Text('CE'),
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4DDAC4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    onTap: () {
                      //Get.toNamed('/saoma');
                      //print(_unameController.text);
                      __get(_unameController.text); //搜索 按钮点击事件.
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //提示框
  _showDialog(widgetContext,
      {String title = '提示', String centonts = '内容', String s1 = ''}) {
    showCupertinoDialog(
      context: widgetContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('$centonts'),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                //确认后执行逻辑..
                //拨打号码
                _makePhoneCall('tel:$s1');

                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('No'),
              isDestructiveAction: false,
              onPressed: () {
                //取消后执行逻辑..
                print('取消');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // URL 启动设备功能
  Future _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
