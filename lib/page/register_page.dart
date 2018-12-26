import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/db/user.dart';
import 'package:flutter_49_yzb/dialog/show_progrogress.dart';
import 'package:flutter_49_yzb/util/baseutil.dart';

class RegisterPage extends StatefulWidget {
  static void pushPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var _userNameController = TextEditingController();
  var _passWordController_1 = TextEditingController();
  var _passWordController_2 = TextEditingController();
  var _nickNameCOntroller = TextEditingController();
  var _focusNodeFirstName = FocusNode();
  var _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: ListView(
        children: <Widget>[
          getRegisterLoginRow(_userNameController, '6-12位数字或字母账号',
              Icon(Icons.account_box), false),
          getRegisterLoginRow(
              _passWordController_1, '6-14位数字或字母密码', Icon(Icons.lock), true),
          getRegisterLoginRow(
              _passWordController_2, '确认密码', Icon(Icons.lock), true),
          getRegisterLoginRow(
              _nickNameCOntroller, '昵称', Icon(Icons.account_circle), false),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(60.0, 10.0, 60.0, 10.0),
              onPressed: _register,
              child: Text(
                '注册',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  bool isRegisting = false;

  void _register() async {
    if (isRegisting) {
      ToastUtil.showCenterShort("正在注册，请稍后...");
      return;
    }
    String userName = _userNameController.text.trim(); //用户名
    String pwd1 = _passWordController_1.text.trim(); //密码
    String pwd2 = _passWordController_2.text.trim(); //确认密码
    String nickName = _nickNameCOntroller.text.trim();
    if (TextUtil.isEmpty(userName) ||
        TextUtil.isEmpty(pwd1) ||
        TextUtil.isEmpty(pwd2)) {
      ToastUtil.showCenterShort('密码或账号不能为空');
      return;
    }
    if (TextUtil.isEmpty(nickName)) {
      ToastUtil.showCenterShort('请输入昵称');
      return;
    }

    if (pwd1 != pwd2) {
      ToastUtil.showCenterShort('两次密码不一致');
      return;
    }
    if (userName.length < 6 ||
        userName.length > 12 ||
        pwd2.length < 6 ||
        pwd2.length > 14) {
      ToastUtil.showCenterShort('账号或密码格式错误');
      return;
    }
    isRegisting = true;
    UserBean userBean=await UserManager.userBean();
    User user=await userBean.findOneByUserName(userName);
    if (user != null) {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => ShowProgress(
                content: '用户已存在',
              ));
    } else {
      User user=User();
      user.userName=userName;
      user.pwd=pwd2;
      user.nickName=nickName;
      var res = await userBean.insert(user);
      userBean.close();
      if (res != 0) {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => ShowProgress(
                  content: '注册成功',
                ));
        Navigator.pop(context);
      } else {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => ShowProgress(
                  content: '注册失败',
                ));
      }
    }
    isRegisting = false;
  }
  Widget getRegisterLoginRow(TextEditingController controller, String hintText,
      Icon icon, bool obscureText) {
    var leftRightPadding = 30.0;
    var topBottomPadding = 4.0;
    var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
      child: TextField(
        keyboardType: TextInputType.number,
        style: hintTips,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
        ),
        autofocus: true,
        obscureText: obscureText, //是否隐藏正在编辑的文本
      ),
    );
  }
}
