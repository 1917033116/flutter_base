import 'package:flutter_49_yzb/util/baseutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const String IS_LOGIN = "isLogin";
  static const String NICK_NAME = "nick_name";
  static const String USER_ACCOUNT = "user_account";
  static const String DEF_NICK_NAME="未登录";
  static const String DEF_HEADER_IMG="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";
  static const String USER_HEADER="user_header";
  static addString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static addInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key, value);
  }

  static Future<String> getString(String key,{String defStr}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String res = preferences.getString(key);
    if (TextUtil.isEmpty(res)) {
      res = defStr;
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