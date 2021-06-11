import 'package:bot_toast/bot_toast.dart';
import 'package:ce_ccsl_new/Utils/httpData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:ld_clinet/Page/Tabs.dart';
import 'theme.dart' as Theme;
//import 'bubble_indication_painter.dart';
import 'package:get/get.dart' hide Response;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:dio/dio.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
      
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String version = '';
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  late PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          //print('$notification');
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: new BoxDecoration(
              // 背景色设置
              color: Colors.grey,
              // gradient: new LinearGradient(
              //   colors: [
              //     Theme.Colors.loginGradientStart,
              //     Theme.Colors.blue,
              //     //Theme.Colors.loginGradientEnd
              //   ],
              //   begin: const FractionalOffset(0.0, 0.0),
              //   end: const FractionalOffset(1.0, 1.0),
              //   stops: [0.0, 1.0],
              //   tileMode: TileMode.clamp,
              // ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: new Image(
                      width: 250.0,
                      height: 121.0,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/logo.png')),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20.0),
                //   child: _buildMenuBar(context),
                // ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      // new ConstrainedBox(
                      //   constraints: const BoxConstraints.expand(),
                      //   child: _buildSignUp(context),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController.dispose();
    super.dispose();
  }

  var _switchValue = false;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
    _getPrefs();
    _packageInfo();
  }

  _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _switchValue = prefs.getBool('switchValue') == null
        ? false
        : prefs.getBool('switchValue')!;
    print('是否记住');
    print(_switchValue);
    if (_switchValue) {
      List<String>? user = prefs.getStringList('user');

      loginEmailController.value = TextEditingValue(text: user![0]);
      loginPasswordController.value = TextEditingValue(text: user[1]);
      // loginEmailController.value = user![0] as TextEditingValue;
      // loginPasswordController.value = user[1] as TextEditingValue;
    }
    setState(() {});
  }

  void showInSnackBar(String value) {
    // 关闭软键盘
    FocusScope.of(context).requestFocus(new FocusNode());
    // 关闭提示框SnackBar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon(
          //   Icons.check,
          //   color: Colors.green,
          // ),
          Expanded(
            child: Text(value),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Tab 切换
  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        //painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "User Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 220.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //     color: Theme.Colors.blue,
                  //     offset: Offset(1.0, 1.0),
                  //     blurRadius: 5.0,
                  //   ),
                  //   BoxShadow(
                  //     color: Color(0xFF9966ff),
                  //     offset: Offset(1.0, 1.0),
                  //     blurRadius: 5.0,
                  //   ),
                  // ],
                  // 按钮颜色设置
                  color: Colors.blue,
                  // gradient: new LinearGradient(
                  //   colors: [
                  //     Theme.Colors.blue,
                  //     Color(0xFF9966ff),
                  //   ],
                  //   // begin: const FractionalOffset(0.2, 0.2),
                  //   // end: const FractionalOffset(1.0, 1.0),
                  //   // stops: [0.0, 1.0],
                  //   // tileMode: TileMode.clamp,
                  // ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  //splashColor: Theme.Colors.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: () {
                    _getUserPassword();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '记住密码'.tr,
                    style: TextStyle(
                      //decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'KhmerOSSiemreap',
                    ),
                  ),
                  CupertinoSwitch(
                      //activeColor: Colors.red,
                      trackColor: Colors.grey[300],
                      value: _switchValue,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _switchValue = value;
                        });
                      })
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          //   child: TextButton(
          //       onPressed: () {},
          //       child: Text(
          //         "Forgot Password?",
          //         style: TextStyle(
          //             decoration: TextDecoration.underline,
          //             color: Colors.white,
          //             fontSize: 16.0,
          //             fontFamily: "KhmerOSSiemreap"),
          //       )),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white10,
          //                 Colors.white,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 15.0, right: 15.0),
          //         child: Text(
          //           "Or",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 16.0,
          //               fontFamily: "WorkSansMedium"),
          //         ),
          //       ),
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white,
          //                 Colors.white10,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(top: 10.0, right: 40.0),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Facebook button pressed"),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.facebookF,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(top: 10.0),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Google button pressed"),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.google,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          Expanded(
            child: Stack(
              children: [
                Positioned(
                  child: Text(
                    'version ' + version,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  bottom: 10,
                )
              ],
              alignment: Alignment.bottomCenter,
            ),
          )
        ],
      ),
    );
  }

  // 获取应用信息
  void _packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    //print(version);
    setState(() {});
  }
  late Response response;
  _getUserPassword() async {
    BotToast.showLoading();
    String username = loginEmailController.text;
    String password = loginPasswordController.text;
    print("用户名:" + username);
    print("密码:" + password);
    print('记住密码:' + _switchValue.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_switchValue) {
      await prefs.setBool('switchValue', _switchValue);
      await prefs.setStringList('user', [username, password]);
    } else {
      await prefs.setBool('switchValue', _switchValue);
    }

    
    var dio = Dio();
    //dio.options.baseUrl = 
    response = await dio.get('http://api.ceccsl.com/api/login/get?Name=$username&Pwd=$password');
    //response = await dio.get('http://api.ceccsl.com/api/login/get?Name=K000001&Pwd=CE123123');
    print(response.data);
    if(response.statusCode == 200){
      if(response.data == null){
        BotToast.closeAllLoading();
        BotToast.showText(text: '用户名或者密码错误'.tr);
      }else if(response.data['Name'] == username){
        BotToast.closeAllLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Name', username);
        Get.off('/');
      }else{
        BotToast.closeAllLoading();
        BotToast.showText(text: '用户名或者密码错误'.tr);
      }
    } else {
      BotToast.closeAllLoading();
      BotToast.showText(text: '网络故障请稍后尝试'.tr);
    }
    
  }

  // 注册
  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 360.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "User Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmation",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 340.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () => showInSnackBar("SignUp button pressed")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
