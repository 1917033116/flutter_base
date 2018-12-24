import 'package:flutter/material.dart';
import 'package:flutter_49_yzb/splash_page.dart';
import 'package:flutter_jpush/flutter_jpush.dart';
void main() {
  runApp(MyApp());
  _startupJpush();

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '亚洲杯',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}

void _startupJpush() async {
  await FlutterJPush.startup();
}