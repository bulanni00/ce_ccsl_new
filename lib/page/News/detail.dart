import 'package:ce_ccsl_new/utils/HttpData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart' hide Response;

class Detail extends StatefulWidget {
  final arguments;
  Detail({Key? key, this.arguments}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List dataList = [];
  var rou = Get.arguments;
  Map detail = {};
  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('details'),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    this.dataList.forEach((v) {
      if (v['id'] == rou['id']) {
        setState(() {
          detail = v;
        });
      }
    });
    
    if (detail.isEmpty) {
      return Text('数据加载中..'.tr);
    } else {
      return Container(
        margin: EdgeInsets.all(13),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${detail['title']}',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${detail['created_at']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              // 分割线
              Container(
                margin: EdgeInsets.only(top: 3.0),
                color: Color(0xffeaeaea),
                constraints: BoxConstraints.expand(height: 1.0),
              ),
              Container(
                child: Html(
                  data: detail['content'],
                  style: {
                    'html': Style(
                        //backgroundColor: Colors.black12,
                        //color: Colors.white,
                        ),
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //请求服务器.
  _getVersion() async {
    late Response response;
    var dio = Dio();
    //dio.options.baseUrl =
    response = await dio.get(
        'https://ce-client-app.oss-ap-southeast-1.aliyuncs.com/CCSL/news/news.json');
    setState(() {
      this.dataList = response.data['data'];
    });
  }
}
