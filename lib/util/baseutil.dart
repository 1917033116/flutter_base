import 'dart:convert';

import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextUtil {
  ///空字符串判断
  static isEmpty(String text) {
    if (text == null || text.trim().length == 0 || text == "null") {
      return true;
    } else
      return false;
  }

  ///
  /// 自定义加密规则
  ///
  ///    @param data
  ///  @return
  static String getJson(String data) {
    String a = "";
    int x = 0;
    if (data.endsWith("==")) {
      a = data.replaceAll("==", "");
      x = 2;
    } else if (data.endsWith("=")) {
      a = data.replaceAll("=", "");
      x = 1;
    } else {
      a = data;
    }
    StringBuffer b = new StringBuffer();
    for (int i = 0; i < a.length - 1; i++) {
      if (i % 2 == 0) {
        b.write(a[i]);
      }
    }
    String bs = b.toString();
    int bLength = bs.length;
    StringBuffer mbs = new StringBuffer();
    for (int i = bLength - 1; i >= 0; i--) {
      mbs.write(bs[i]);
    }
    String c = mbs.toString().trim();
    String d = "";
    if (x == 1) {
      d = c + "=";
    } else if (x == 2) {
      d = c + "==";
    } else {
      d = c;
    }

    Uint8List uint8list = base64.decode(d);
    String e = String.fromCharCodes(uint8list);
    String f = e.substring(2, e.length - 4);
    return f;
  }
}

class RegexUtils {
  ///
  ///  @param sourceTime 时间区间,半闭合,如[10:00-20:00)
  ///  @param curTime    需要判断的时间 如10:00
  /// @return
  ///  @throws IllegalArgumentException System.out.println(isInTime("20:00-01:00", "00:00"));
  ///                                   System.out.println(isInTime("20:00-01:00", "03:00"));
  ///                                 System.out.println(isInTime("20:00-23:00", "03:00"));
  ///                                System.out.println(DateTest.isInTime("20:00-23:00", "22:00"));
  ///                                  System.out.println(DateTest.isInTime("20:00-23:00", "18:00"));
  ///                                  System.out.println(DateTest.isInTime("20:00-23:00", "20:00"));
  ///                                System.out.println(DateTest.isInTime("20:00-23:00", "23:00"));
  ///
  ///判断某一时间是否在一个区间内

  static bool isInTime(String sourceTime, String curTime) {
    if (sourceTime == null ||
        !sourceTime.contains("_") ||
        !sourceTime.contains(":")) {
      return false;
    }
    if (curTime == null || !curTime.contains(":")) {
      return false;
    }
    List<String> args = sourceTime.split("_");
    if (args != null && args.length >= 2) {
      String sTime = "14:00";
      String eTime = "19:00";
      DateTime startTime = DateTime.parse(sTime);
      DateTime endTime = DateTime.parse(eTime);
      DateTime nowTime = DateTime.parse(curTime);
      var seconds1 = startTime.difference(nowTime).inSeconds;
      var seconds2 = endTime.difference(nowTime).inSeconds;
      print("$seconds1----$seconds2");
    } else {
      return false;
    }
  }

  static String getValue(String regex, String str) {
    String id = "";
    RegExp exp = RegExp(regex);
    Iterable<Match> match = exp.allMatches(str);
    if (match != null) {
      for (Match m in match) {
        id = m.group(1);
      }
    }
    return id;
  }
}

///SharedPreferences 工具类
class SpUtils {
  static String IS_LOGIN = "isLogin";
  static String NICK_NAME = "nick_name";
  static String USER_ACCOUNT = "user_account";

  static addString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static addInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String res = preferences.getString(key);
    if (TextUtil.isEmpty(res)) {
      res = "";
    }
    return res;
  }

  static addBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool res = preferences.getBool(key);
    if (res == null) {
      res = false;
    }
    return res;
  }
}

class ToastUtil {
  static showCenterShort(
    String msg,
  ) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }
}
