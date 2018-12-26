import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/page/login_register_page.dart';
import 'package:flutter_49_yzb/page/news_page.dart';
import 'package:flutter_49_yzb/page/schedule_page.dart';
import 'package:flutter_49_yzb/page/settings_page.dart';
import 'package:flutter_49_yzb/sp/sp_util.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_49_yzb/util/baseutil.dart';
import 'package:flutter/cupertino.dart';

class MjPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MjPageState();
  }
}

class _MjPageState extends State<MjPage> {
  String title = "新闻";
  Widget newsPage = NewsPage();
  Widget schedulePage = SchedulePage();
  Widget settingsPage = SettingsPage();
  Widget body;
  String nickName = SpUtils.DEF_NICK_NAME;
  String userName = "";
  String imgHeaderBase64 = SpUtils.DEF_HEADER_IMG;
  bool isVideo = false;
  File _imageFile;

  static final String LOGIN = "登录/注册";
  static final String LOGIN_OUT = "退出登录";
  String LOGIN_OR_OUT = LOGIN;

  @override
  void initState() {
    super.initState();
    body = newsPage;
    initUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    var textBg = Paint();
    textBg.color = Color(0x55585858);
    Widget userHeader = Container(
      color: Colors.blue,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: UserAccountsDrawerHeader(
              accountName: new Text(nickName),
              accountEmail: new Text(userName),
              currentAccountPicture: new GestureDetector(
                child: ClipOval(
                  child: Image.memory(
                    base64.decode(imgHeaderBase64),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                onTap: _clickHeaderImg,
              ),
            ),
          ),
          RaisedButton(
              color: Color(0x22585858),
              onPressed: _clickLogin,
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Text(
                LOGIN_OR_OUT,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              )),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            userHeader, // 可在这里替换自定义的header
            getListTile("新闻", "NEWS", NewsPage()),
            getListTile("赛程", "SCHEDULE", SchedulePage()),
            getListTile("设置", "SETTINGS", SettingsPage()),
          ],
        ),
      ),
    );
  }

  //点击登录注册
  void _clickLogin() async {
    if (LOGIN_OR_OUT == LOGIN) {
      bool isLoginSuccess = await LoginPage.lunchLoginPage(context);
      if (isLoginSuccess) initUserInfo();
    } else {
      _LoginOut();
    }
  }

  void _LoginOut() async{
    await SpUtils.addBool(SpUtils.IS_LOGIN, false);
    initUserInfo();
  }

//点击头像
  void _clickHeaderImg() async {
    bool isLogin = await SpUtils.getBool(SpUtils.IS_LOGIN);
    if (!isLogin) {
      ToastUtil.showCenterShort("请先登录");
      bool isLoginSuccess = await LoginPage.lunchLoginPage(context);
      if (isLoginSuccess) initUserInfo();
      return;
    }
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    List<int> bytes = await _imageFile.readAsBytes();
    setState(() {
      imgHeaderBase64 = base64.encode(bytes);
      SpUtils.addString(SpUtils.USER_HEADER, imgHeaderBase64);
    });
  }

  ListTile getListTile(String title, String logo, Widget page) {
    return ListTile(
      title: Text(title),
      leading: new CircleAvatar(
        child: new Text(
          logo,
          style: TextStyle(fontSize: 7),
        ),
      ),
      onTap: () {
        setState(() {
          this.title = title;
          body = page;
        });
        Navigator.pop(context);
      },
    );
  }

  void initUserInfo() async {
    bool isLogin = await SpUtils.getBool(SpUtils.IS_LOGIN);

    if (!isLogin) {
      LOGIN_OR_OUT=LOGIN;
      nickName=SpUtils.DEF_NICK_NAME;
      userName="";
      imgHeaderBase64=SpUtils.DEF_HEADER_IMG;
    }else{
      LOGIN_OR_OUT=LOGIN_OUT;
      nickName = await SpUtils.getString(SpUtils.NICK_NAME,
          defStr: SpUtils.DEF_NICK_NAME);
      userName = await SpUtils.getString(SpUtils.USER_ACCOUNT, defStr: "");
      imgHeaderBase64 = await SpUtils.getString(SpUtils.USER_HEADER,
          defStr: SpUtils.DEF_HEADER_IMG);
    }
    setState(() {});
  }
}
