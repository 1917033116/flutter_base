import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }

}
class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("SettingsPage"),
      ),
    );
  }

}