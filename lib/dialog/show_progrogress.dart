import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/util/baseutil.dart';

class ShowProgress extends StatefulWidget {
  ShowProgress({Key key,this.content}):super(key:key);
  String content;

  @override
  _ShowProgressState createState() => new _ShowProgressState();
}

class _ShowProgressState extends State<ShowProgress> {
  @override
  initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      ToastUtil.showCenterShort(widget.content);
      Navigator.of(context).pop();
      t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(), //获取控件实例
    );
  }
}
