import 'app_barcode_scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
///
/// FullScreenScannerPage
class FullScreenScannerPage extends StatefulWidget {
  @override
  _FullScreenScannerPageState createState() => _FullScreenScannerPageState();
}

class _FullScreenScannerPageState extends State<FullScreenScannerPage> {
  String _code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text("「$_code」"),
          //   ],
          // ),
          Expanded(
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                //_scannerController.closeFlash();
               //Get.offAllNamed('/HomePage', arguments: {'code': code});
                Get.back(result: {'success':'ok', 'code':code});
                // setState(() {
                //   _code = code;
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}