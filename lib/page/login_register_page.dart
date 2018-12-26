import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/db/user.dart';
import 'package:flutter_49_yzb/dialog/show_progrogress.dart';
import 'package:flutter_49_yzb/page/register_page.dart';
import 'package:flutter_49_yzb/sp/sp_util.dart';
import 'package:flutter_49_yzb/util/baseutil.dart';

class LoginPage extends StatefulWidget {
  static Future<bool> lunchLoginPage(BuildContext context) async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return LoginPage();
    }));
  }

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}
bool isLoginSuccess=false;
class _LoginPageState extends State<LoginPage> {
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _pwd_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 30.0),
        child: ListView(
          children: <Widget>[
            getRow(_name_controller, "请输入账号", Icon(Icons.account_box), false),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: getRow(_pwd_controller, "请输入密码", Icon(Icons.lock), true),
            ),
            Row(
              children: <Widget>[
                getButton(
                    Colors.blue,
                    EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                    "登录",
                    clickLogin),
                getButton(
                    Color(0xffefefef),
                    EdgeInsets.fromLTRB(0.0, 30.0, 20.0, 0.0),
                    "注册",
                    clickRegister)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clickLogin() async {
    String userName = _name_controller.text;
    String pwd = _pwd_controller.text;
    if (TextUtil.isEmpty(userName) ||
        TextUtil.isEmpty(pwd) ||
        userName.length < 6 ||
        userName.length > 12 ||
        pwd.length < 6 ||
        pwd.length > 14) {
      ToastUtil.showCenterShort("账号或密码格式错误");
      return;
    }
    UserBean userBean = await UserManager.userBean();
    User user = await userBean.findOneByUserName(userName);
    userBean.close();
    if (user != null) {
      if (user.pwd != pwd) {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => ShowProgress(
                  content: '密码错误',
                ));
      } else {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => ShowProgress(
                  content: '登录成功',
                ));
        await SpUtils.addBool(SpUtils.IS_LOGIN, true);
        await SpUtils.addString(SpUtils.NICK_NAME, user.nickName);
        await SpUtils.addString(SpUtils.USER_ACCOUNT, user.userName);
        Navigator.pop(context, true);
      }
    } else {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => ShowProgress(
                content: '账号不存在',
              ));
    }
  }

  void clickRegister() {
    RegisterPage.pushPage(context);
  }

  Widget getRow(TextEditingController controller, String hintText, Icon icon,
      bool obscureText) {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 15.0, color: Colors.black26),
      controller: controller,
      decoration: InputDecoration(hintText: hintText, prefixIcon: icon),
      autofocus: true,
      obscureText: obscureText,
    );
  }

//  EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0)
  Widget getButton(Color bgColor, EdgeInsetsGeometry margin, String text,
      VoidCallback callBack) {
    return Expanded(
        child: Container(
      color: bgColor,
      margin: margin,
      child: FlatButton(
        onPressed: callBack,
        child: Text(
          text,
          style: TextStyle(color: Colors.black54, fontSize: 16.0),
        ),
      ),
    ));
  }
}
